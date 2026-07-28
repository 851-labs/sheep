// Generated from Herdr protocol 17, schema 1.
// Do not edit by hand; run Scripts/generate-herdr-sdk.mjs.
// To parse the JSON, add this file to your project and do:
//
//   let herdrSubscriptionTypes = try HerdrSubscriptionTypes(json)

import Foundation

// MARK: - HerdrSubscriptionTypes
public struct HerdrSubscriptionTypes: Codable, Sendable {
    public let subscriptionEventEnvelope: HerdrSubscriptionSubscriptionEventEnvelope

    public enum CodingKeys: String, CodingKey {
        case subscriptionEventEnvelope = "SubscriptionEventEnvelope"
    }

    public init(subscriptionEventEnvelope: HerdrSubscriptionSubscriptionEventEnvelope) {
        self.subscriptionEventEnvelope = subscriptionEventEnvelope
    }
}

// MARK: HerdrSubscriptionTypes convenience initializers and mutators

public extension HerdrSubscriptionTypes {
    init(data: Data) throws {
        self = try newHerdrSubscriptionJSONDecoder().decode(HerdrSubscriptionTypes.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        subscriptionEventEnvelope: HerdrSubscriptionSubscriptionEventEnvelope? = nil
    ) -> HerdrSubscriptionTypes {
        return HerdrSubscriptionTypes(
            subscriptionEventEnvelope: subscriptionEventEnvelope ?? self.subscriptionEventEnvelope
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrSubscriptionJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrSubscriptionSubscriptionEventEnvelope
public struct HerdrSubscriptionSubscriptionEventEnvelope: Codable, Sendable {
    public let data: HerdrSubscriptionData
    public let event: HerdrSubscriptionEvent

    public enum CodingKeys: String, CodingKey {
        case data = "data"
        case event = "event"
    }

    public init(data: HerdrSubscriptionData, event: HerdrSubscriptionEvent) {
        self.data = data
        self.event = event
    }
}

// MARK: HerdrSubscriptionSubscriptionEventEnvelope convenience initializers and mutators

public extension HerdrSubscriptionSubscriptionEventEnvelope {
    init(data: Data) throws {
        self = try newHerdrSubscriptionJSONDecoder().decode(HerdrSubscriptionSubscriptionEventEnvelope.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        data: HerdrSubscriptionData? = nil,
        event: HerdrSubscriptionEvent? = nil
    ) -> HerdrSubscriptionSubscriptionEventEnvelope {
        return HerdrSubscriptionSubscriptionEventEnvelope(
            data: data ?? self.data,
            event: event ?? self.event
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrSubscriptionJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrSubscriptionData
public struct HerdrSubscriptionData: Codable, Sendable {
    public let matchedLine: String?
    public let paneID: PaneID
    public let read: HerdrSubscriptionRead?
    public let agent: String?
    public let agentStatus: HerdrSubscriptionAgentStatus?
    public let displayAgent: String?
    public let stateLabels: [String: String]?
    public let title: String?
    public let workspaceID: WorkspaceID?
    public let scroll: HerdrSubscriptionScroll?

    public enum CodingKeys: String, CodingKey {
        case matchedLine = "matched_line"
        case paneID = "pane_id"
        case read = "read"
        case agent = "agent"
        case agentStatus = "agent_status"
        case displayAgent = "display_agent"
        case stateLabels = "state_labels"
        case title = "title"
        case workspaceID = "workspace_id"
        case scroll = "scroll"
    }

    public init(matchedLine: String?, paneID: PaneID, read: HerdrSubscriptionRead?, agent: String?, agentStatus: HerdrSubscriptionAgentStatus?, displayAgent: String?, stateLabels: [String: String]?, title: String?, workspaceID: WorkspaceID?, scroll: HerdrSubscriptionScroll?) {
        self.matchedLine = matchedLine
        self.paneID = paneID
        self.read = read
        self.agent = agent
        self.agentStatus = agentStatus
        self.displayAgent = displayAgent
        self.stateLabels = stateLabels
        self.title = title
        self.workspaceID = workspaceID
        self.scroll = scroll
    }
}

// MARK: HerdrSubscriptionData convenience initializers and mutators

public extension HerdrSubscriptionData {
    init(data: Data) throws {
        self = try newHerdrSubscriptionJSONDecoder().decode(HerdrSubscriptionData.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        matchedLine: String?? = nil,
        paneID: PaneID? = nil,
        read: HerdrSubscriptionRead?? = nil,
        agent: String?? = nil,
        agentStatus: HerdrSubscriptionAgentStatus?? = nil,
        displayAgent: String?? = nil,
        stateLabels: [String: String]?? = nil,
        title: String?? = nil,
        workspaceID: WorkspaceID?? = nil,
        scroll: HerdrSubscriptionScroll?? = nil
    ) -> HerdrSubscriptionData {
        return HerdrSubscriptionData(
            matchedLine: matchedLine ?? self.matchedLine,
            paneID: paneID ?? self.paneID,
            read: read ?? self.read,
            agent: agent ?? self.agent,
            agentStatus: agentStatus ?? self.agentStatus,
            displayAgent: displayAgent ?? self.displayAgent,
            stateLabels: stateLabels ?? self.stateLabels,
            title: title ?? self.title,
            workspaceID: workspaceID ?? self.workspaceID,
            scroll: scroll ?? self.scroll
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrSubscriptionJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrSubscriptionAgentStatus: String, Codable, Sendable {
    case blocked = "blocked"
    case done = "done"
    case idle = "idle"
    case unknown = "unknown"
    case working = "working"
}

// MARK: - HerdrSubscriptionRead
public struct HerdrSubscriptionRead: Codable, Sendable {
    public let format: HerdrSubscriptionFormat
    public let paneID: PaneID
    public let revision: Int
    public let source: HerdrSubscriptionSource
    public let tabID: TabID
    public let text: String
    public let truncated: Bool
    public let workspaceID: WorkspaceID

    public enum CodingKeys: String, CodingKey {
        case format = "format"
        case paneID = "pane_id"
        case revision = "revision"
        case source = "source"
        case tabID = "tab_id"
        case text = "text"
        case truncated = "truncated"
        case workspaceID = "workspace_id"
    }

    public init(format: HerdrSubscriptionFormat, paneID: PaneID, revision: Int, source: HerdrSubscriptionSource, tabID: TabID, text: String, truncated: Bool, workspaceID: WorkspaceID) {
        self.format = format
        self.paneID = paneID
        self.revision = revision
        self.source = source
        self.tabID = tabID
        self.text = text
        self.truncated = truncated
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrSubscriptionRead convenience initializers and mutators

public extension HerdrSubscriptionRead {
    init(data: Data) throws {
        self = try newHerdrSubscriptionJSONDecoder().decode(HerdrSubscriptionRead.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        format: HerdrSubscriptionFormat? = nil,
        paneID: PaneID? = nil,
        revision: Int? = nil,
        source: HerdrSubscriptionSource? = nil,
        tabID: TabID? = nil,
        text: String? = nil,
        truncated: Bool? = nil,
        workspaceID: WorkspaceID? = nil
    ) -> HerdrSubscriptionRead {
        return HerdrSubscriptionRead(
            format: format ?? self.format,
            paneID: paneID ?? self.paneID,
            revision: revision ?? self.revision,
            source: source ?? self.source,
            tabID: tabID ?? self.tabID,
            text: text ?? self.text,
            truncated: truncated ?? self.truncated,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrSubscriptionJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrSubscriptionFormat: String, Codable, Sendable {
    case ansi = "ansi"
    case text = "text"
}

public enum HerdrSubscriptionSource: String, Codable, Sendable {
    case detection = "detection"
    case recent = "recent"
    case recentUnwrapped = "recent_unwrapped"
    case visible = "visible"
}

// MARK: - HerdrSubscriptionScroll
public struct HerdrSubscriptionScroll: Codable, Sendable {
    public let maxOffsetFromBottom: Int
    public let offsetFromBottom: Int
    public let viewportRows: Int

    public enum CodingKeys: String, CodingKey {
        case maxOffsetFromBottom = "max_offset_from_bottom"
        case offsetFromBottom = "offset_from_bottom"
        case viewportRows = "viewport_rows"
    }

    public init(maxOffsetFromBottom: Int, offsetFromBottom: Int, viewportRows: Int) {
        self.maxOffsetFromBottom = maxOffsetFromBottom
        self.offsetFromBottom = offsetFromBottom
        self.viewportRows = viewportRows
    }
}

// MARK: HerdrSubscriptionScroll convenience initializers and mutators

public extension HerdrSubscriptionScroll {
    init(data: Data) throws {
        self = try newHerdrSubscriptionJSONDecoder().decode(HerdrSubscriptionScroll.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        maxOffsetFromBottom: Int? = nil,
        offsetFromBottom: Int? = nil,
        viewportRows: Int? = nil
    ) -> HerdrSubscriptionScroll {
        return HerdrSubscriptionScroll(
            maxOffsetFromBottom: maxOffsetFromBottom ?? self.maxOffsetFromBottom,
            offsetFromBottom: offsetFromBottom ?? self.offsetFromBottom,
            viewportRows: viewportRows ?? self.viewportRows
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrSubscriptionJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrSubscriptionEvent: String, Codable, Sendable {
    case paneAgentStatusChanged = "pane.agent_status_changed"
    case paneOutputMatched = "pane.output_matched"
    case paneScrollChanged = "pane.scroll_changed"
}

// MARK: - Helper functions for creating encoders and decoders

func newHerdrSubscriptionJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newHerdrSubscriptionJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
