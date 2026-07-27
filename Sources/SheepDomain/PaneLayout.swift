public struct PaneLayout: Codable, Equatable, Sendable {
    public let workspaceID: WorkspaceID
    public let tabID: TabID
    public let zoomed: Bool
    public let focusedPaneID: PaneID
    public let root: Node

    public init(
        workspaceID: WorkspaceID,
        tabID: TabID,
        zoomed: Bool,
        focusedPaneID: PaneID,
        root: Node
    ) {
        self.workspaceID = workspaceID
        self.tabID = tabID
        self.zoomed = zoomed
        self.focusedPaneID = focusedPaneID
        self.root = root
    }

    private enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case tabID = "tab_id"
        case zoomed
        case focusedPaneID = "focused_pane_id"
        case root
    }

    public indirect enum Node: Equatable, Sendable {
        case pane(PaneID)
        case split(direction: SplitDirection, ratio: Double, first: Node, second: Node)

        public func paneIDs() -> [PaneID] {
            switch self {
            case let .pane(id):
                [id]
            case let .split(_, _, first, second):
                first.paneIDs() + second.paneIDs()
            }
        }

        public func leavesWithPaths(path: [Bool] = []) -> [(paneID: PaneID, path: [Bool])] {
            switch self {
            case let .pane(id):
                [(id, path)]
            case let .split(_, _, first, second):
                first.leavesWithPaths(path: path + [false])
                    + second.leavesWithPaths(path: path + [true])
            }
        }
    }

    public enum SplitDirection: String, Codable, Equatable, Sendable {
        case right
        case down
    }
}

extension PaneLayout.Node: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case paneID = "pane_id"
        case direction
        case ratio
        case first
        case second
    }

    private enum Kind: String, Codable {
        case pane
        case split
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Kind.self, forKey: .type) {
        case .pane:
            self = .pane(try container.decode(PaneID.self, forKey: .paneID))
        case .split:
            self = .split(
                direction: try container.decode(PaneLayout.SplitDirection.self, forKey: .direction),
                ratio: try container.decode(Double.self, forKey: .ratio),
                first: try container.decode(Self.self, forKey: .first),
                second: try container.decode(Self.self, forKey: .second)
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .pane(id):
            try container.encode(Kind.pane, forKey: .type)
            try container.encode(id, forKey: .paneID)
        case let .split(direction, ratio, first, second):
            try container.encode(Kind.split, forKey: .type)
            try container.encode(direction, forKey: .direction)
            try container.encode(ratio, forKey: .ratio)
            try container.encode(first, forKey: .first)
            try container.encode(second, forKey: .second)
        }
    }
}
