#!/usr/bin/env node

import crypto from "node:crypto";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import process from "node:process";
import { spawnSync } from "node:child_process";

const repository = process.cwd();
const schemaPath = path.join(
  repository,
  ".repos/herdr/docs/next/api/herdr-api.schema.json",
);
const outputDirectory = path.join(
  repository,
  "Packages/HerdrSDK/Sources/HerdrSDK/Generated",
);
const quicktype = path.join(
  repository,
  "Tools/HerdrSDKGenerator/node_modules/.bin/quicktype",
);

if (!fs.existsSync(schemaPath)) {
  throw new Error(`Herdr schema is missing at ${schemaPath}`);
}
if (!fs.existsSync(quicktype)) {
  throw new Error(
    "Generator dependencies are missing. Run `npm ci --prefix Tools/HerdrSDKGenerator`.",
  );
}

const schemaData = fs.readFileSync(schemaPath);
const schema = JSON.parse(schemaData);
if (schema.protocol !== 18 || schema.schema_version !== 1) {
  throw new Error(
    `Expected Herdr protocol 18/schema 1, found ${schema.protocol}/${schema.schema_version}`,
  );
}

fs.mkdirSync(outputDirectory, { recursive: true });
const temporaryDirectory = fs.mkdtempSync(
  path.join(os.tmpdir(), "herdr-sdk-generator-"),
);

const groups = [
  {
    name: "Request",
    schemaName: "request",
    roots: Object.keys(schema.schemas.request.$defs)
      .filter((name) => !["EmptyParams", "PingParams"].includes(name)),
  },
  {
    name: "Response",
    schemaName: "success_response",
    roots: ["ResponseResult"],
  },
  {
    name: "Event",
    schemaName: "event",
    roots: [],
    rootType: "EventEnvelope",
  },
  {
    name: "Subscription",
    schemaName: "subscription_event",
    roots: [],
    rootType: "SubscriptionEventEnvelope",
  },
];

for (const group of groups) {
  const properties = Object.fromEntries(
    group.roots.map((name) => [
      name,
      { $ref: `#/schemas/${group.schemaName}/$defs/${name}` },
    ]),
  );
  if (group.rootType) {
    properties[group.rootType] = { $ref: `#/schemas/${group.schemaName}` };
  }
  const required = Object.keys(properties);
  const wrapper = {
    $schema: schema.$schema,
    type: "object",
    properties,
    required,
    schemas: schema.schemas,
  };
  const wrapperPath = path.join(
    temporaryDirectory,
    `${group.name.toLowerCase()}.schema.json`,
  );
  const generatedPath = path.join(
    outputDirectory,
    `${group.name}Models.generated.swift`,
  );
  fs.writeFileSync(wrapperPath, JSON.stringify(wrapper, null, 2));

  const result = spawnSync(
    quicktype,
    [
      "--lang",
      "swift",
      "--src-lang",
      "schema",
      "--src",
      wrapperPath,
      "--top-level",
      `Herdr${group.name}Types`,
      "--sendable",
      "--access-level",
      "public",
      "--density",
      "normal",
      "--type-prefix",
      `Herdr${group.name}`,
      "--out",
      generatedPath,
    ],
    { encoding: "utf8" },
  );
  if (result.status !== 0) {
    throw new Error(result.stderr || result.stdout);
  }

  let source = fs.readFileSync(generatedPath, "utf8");
  source = source.replace(
    /^\/\/ This file was generated.*\n/,
    `// Generated from Herdr protocol ${schema.protocol}, schema ${schema.schema_version}.\n// Do not edit by hand; run Tools/HerdrSDKGenerator/generate.mjs.\n`,
  );
  source = source.replaceAll("JSONAny", `Herdr${group.name}JSONValue`);
  source = source.replaceAll("JSONNull", `Herdr${group.name}JSONNull`);
  source = source.replaceAll(
    "JSONCodingKey",
    `Herdr${group.name}JSONCodingKey`,
  );
  source = source.replaceAll(
    "newJSONDecoder",
    `newHerdr${group.name}JSONDecoder`,
  );
  source = source.replaceAll(
    "newJSONEncoder",
    `newHerdr${group.name}JSONEncoder`,
  );
  source = source.replace(
    /public class (Herdr[^:]+): Codable, Sendable/g,
    "public final class $1: Codable, Sendable",
  );
  // ResponseResult currently expands to a large product type. Keeping it as a
  // struct makes HerdrSuccessResult exceed the cooperative executor's stack
  // while decoding, so box the generated root response value.
  if (group.name === "Response") {
    source = source.replace(
      "public struct HerdrResponseResponse: Codable, Sendable",
      "public final class HerdrResponseResponse: Codable, Sendable",
    );
    source = source.replace(
      /    init\(data: Data\) throws \{\n        self = try newHerdrResponseJSONDecoder\(\)\.decode\(HerdrResponseResponse\.self, from: data\)\n    \}\n\n    init\(_ json: String, using encoding: String\.Encoding = \.utf8\) throws \{\n        guard let data = json\.data\(using: encoding\) else \{\n            throw NSError\(domain: "JSONDecoding", code: 0, userInfo: nil\)\n        \}\n        try self\.init\(data: data\)\n    \}\n\n    init\(fromURL url: URL\) throws \{\n        try self\.init\(data: try Data\(contentsOf: url\)\)\n    \}\n\n/,
      "",
    );
  }
  source = source.replace(
    new RegExp(`class Herdr${group.name}JSONCodingKey:`, "g"),
    `final class Herdr${group.name}JSONCodingKey:`,
  );
  source = source.replace(
    new RegExp(
      `public class Herdr${group.name}JSONValue: Codable`,
      "g",
    ),
    `public final class Herdr${group.name}JSONValue: Codable, @unchecked Sendable`,
  );
  source = source.replace(
    new RegExp(
      `public class Herdr${group.name}JSONNull: Codable, Hashable`,
      "g",
    ),
    `public final class Herdr${group.name}JSONNull: Codable, Hashable, Sendable`,
  );
  source = source.replace(
    /public var hashValue: Int \{\n\s+return 0\n\s+\}/g,
    "public func hash(into hasher: inout Hasher) {\n        hasher.combine(0)\n    }",
  );
  for (const [suffix, type] of [
    ["[Ww]orkspaceID", "WorkspaceID"],
    ["[Tt]abID", "TabID"],
    ["[Pp]aneID", "PaneID"],
    ["[Tt]erminalID", "TerminalID"],
  ]) {
    source = source.replace(
      new RegExp(`([A-Za-z0-9_]*${suffix}): String`, "g"),
      `$1: ${type}`,
    );
  }
  fs.writeFileSync(generatedPath, source);
}

const requestVariants = schema.schemas.request.oneOf.map((entry) => ({
  method: entry.properties.method.const,
  params:
    entry.properties.params.$ref?.split("/").at(-1) ??
    (() => {
      throw new Error(`Method ${entry.properties.method.const} has no params ref`);
    })(),
}));
const resultTypes =
  schema.schemas.success_response.$defs.ResponseResult.oneOf.map(
    (entry) => entry.properties.type.const,
  );
const eventTypes = schema.schemas.event.$defs.EventKind.enum;
const subscriptionVariants =
  schema.schemas.request.$defs.Subscription.oneOf.map(
    (entry) => entry.properties.type.const,
  );
const subscriptionEventTypes =
  schema.schemas.subscription_event.$defs.SubscriptionEventKind.enum;
const schemaHash = crypto.createHash("sha256").update(schemaData).digest("hex");

const swiftStringArray = (values, indentation = "        ") =>
  values.map((value) => `${indentation}"${value}",`).join("\n");
const methodCases = requestVariants
  .map(
    ({ method }) =>
      `    case ${swiftIdentifier(method)} = "${method}"`,
  )
  .join("\n");

const endpointFunctions = requestVariants
  .map(({ method, params }) => {
    const functionName = swiftIdentifier(method);
    const parameterType =
      params === "EmptyParams" || params === "PingParams"
        ? "HerdrEmptyParameters"
        : `HerdrRequest${params}`;
    const defaultValue =
      params === "EmptyParams" || params === "PingParams" ? " = .init()" : "";
    return `    public static func ${functionName}(_ params: ${parameterType}${defaultValue}) -> HerdrEndpoint<${parameterType}> {
        HerdrEndpoint(method: .${functionName}, params: params)
    }`;
  })
  .join("\n\n");
const resultCases = resultTypes
  .map((type) => `    case ${swiftIdentifier(type)}(HerdrResponseResponse)`)
  .join("\n");
const resultSwitchCases = resultTypes
  .map(
    (type) =>
      `        case .${swiftIdentifier(type)}: self = .${swiftIdentifier(type)}(value)`,
  )
  .join("\n");

const catalog = `// Generated from Herdr protocol ${schema.protocol}, schema ${schema.schema_version}.
// Do not edit by hand; run Tools/HerdrSDKGenerator/generate.mjs.

import Foundation

public enum HerdrProtocolMetadata {
    public static let protocolVersion = ${schema.protocol}
    public static let schemaVersion = ${schema.schema_version}
    public static let schemaSHA256 = "${schemaHash}"
}

public enum HerdrMethod: String, Codable, CaseIterable, Sendable {
${methodCases}

    // The binary stream is documented separately and intentionally omitted
    // from the JSON request schema.
    case paneGraphicsStream = "pane.graphics.stream"
}

public enum HerdrSchemaCatalog {
    public static let methods: Set<String> = [
${swiftStringArray([...requestVariants.map((item) => item.method), "pane.graphics.stream"])}
    ]

    public static let resultTypes: Set<String> = [
${swiftStringArray(resultTypes)}
    ]

    public static let eventTypes: Set<String> = [
${swiftStringArray(eventTypes)}
    ]

    public static let subscriptionTypes: Set<String> = [
${swiftStringArray(subscriptionVariants)}
    ]

    public static let subscriptionEventTypes: Set<String> = [
${swiftStringArray(subscriptionEventTypes)}
    ]
}

public enum HerdrSuccessResult: Codable, Sendable {
${resultCases}

    public init(from decoder: Decoder) throws {
        let discriminator = try decoder.container(
            keyedBy: HerdrResultDiscriminatorKey.self
        ).decode(String.self, forKey: .type)
        guard HerdrSchemaCatalog.resultTypes.contains(discriminator) else {
            throw HerdrCompatibilityError.unknownResultDiscriminator(discriminator)
        }
        let value = try HerdrResponseResponse(from: decoder)
        switch value.type {
${resultSwitchCases}
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case let .${resultTypes.map(swiftIdentifier).join("(value), let .")}(value):
            try value.encode(to: encoder)
        }
    }

    public var value: HerdrResponseResponse {
        switch self {
        case let .${resultTypes.map(swiftIdentifier).join("(value), let .")}(value):
            value
        }
    }
}

private enum HerdrResultDiscriminatorKey: String, CodingKey {
    case type
}

public enum HerdrEndpoints {
${endpointFunctions}
}
`;
fs.writeFileSync(
  path.join(outputDirectory, "SchemaCatalog.generated.swift"),
  catalog,
);

function swiftIdentifier(value) {
  const words = value.split(/[._-]/g);
  const identifier =
    words[0] +
    words
      .slice(1)
      .map((word) => word[0].toUpperCase() + word.slice(1))
      .join("");
  return ["repeat", "internal", "default", "switch"].includes(identifier)
    ? `\`${identifier}\``
    : identifier;
}

fs.rmSync(temporaryDirectory, { recursive: true, force: true });
console.log(
  `Generated HerdrSDK protocol ${schema.protocol} (${requestVariants.length} methods, ${resultTypes.length} results).`,
);
