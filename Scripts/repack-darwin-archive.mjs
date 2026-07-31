#!/usr/bin/env node

// Xcode 27's linker requires archive members to start on 8-byte boundaries.
// Zig emits valid Darwin archives with 2-byte member alignment, so this
// utility expands the archive and lets Apple's `ar` repack it for the local SDK.

import {
  mkdirSync,
  mkdtempSync,
  readFileSync,
  renameSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { tmpdir } from "node:os";
import { basename, join, resolve } from "node:path";
import { spawnSync } from "node:child_process";

const [, , inputArgument, outputArgument = inputArgument] = process.argv;
if (!inputArgument) {
  throw new Error("usage: repack-darwin-archive.mjs <input.a> [output.a]");
}

const input = resolve(inputArgument);
const output = resolve(outputArgument);
const archive = readFileSync(input);
if (archive.subarray(0, 8).toString("ascii") !== "!<arch>\n") {
  throw new Error(`${input} is not an ar archive`);
}

const directory = mkdtempSync(join(tmpdir(), "sheep-ghostty-archive-"));
const members = [];
let offset = 8;
let index = 0;

try {
  while (offset + 60 <= archive.length) {
    const header = archive.subarray(offset, offset + 60);
    if (header.subarray(58, 60).toString("ascii") !== "`\n") {
      throw new Error(`invalid member header at byte ${offset}`);
    }

    const rawName = header.subarray(0, 16).toString("ascii").trim();
    const size = Number.parseInt(header.subarray(48, 58).toString("ascii").trim(), 10);
    if (!Number.isFinite(size)) throw new Error(`invalid member size at byte ${offset}`);

    let contentOffset = offset + 60;
    let contentSize = size;
    let name = rawName.replace(/\/$/, "");
    if (rawName.startsWith("#1/")) {
      const nameLength = Number.parseInt(rawName.slice(3), 10);
      name = archive.subarray(contentOffset, contentOffset + nameLength)
        .toString("utf8")
        .replace(/\0+$/, "");
      contentOffset += nameLength;
      contentSize -= nameLength;
    }

    if (name && name !== "/" && name !== "__.SYMDEF" && contentSize > 0) {
      const memberDirectory = join(directory, String(index).padStart(4, "0"));
      mkdirSync(memberDirectory);
      const file = join(memberDirectory, basename(name));
      writeFileSync(file, archive.subarray(contentOffset, contentOffset + contentSize), {
        mode: 0o600,
      });
      members.push(file);
      index += 1;
    }

    offset += 60 + size;
    if (offset % 2 !== 0) offset += 1;
  }

  const temporaryOutput = join(directory, "aligned.a");
  const result = spawnSync("/usr/bin/ar", ["rcs", temporaryOutput, ...members], {
    encoding: "utf8",
  });
  if (result.status !== 0) {
    throw new Error(result.stderr || result.stdout || "Apple ar failed");
  }
  renameSync(temporaryOutput, output);
  process.stdout.write(`repacked ${members.length} members into ${output}\n`);
} finally {
  rmSync(directory, { recursive: true, force: true });
}
