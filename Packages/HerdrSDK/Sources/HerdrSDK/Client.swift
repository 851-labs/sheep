import Foundation

public actor HerdrClient {
    private let endpointProvider: any HerdrEndpointProvider
    let sessionObservationTiming: HerdrSessionObservationTiming
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    var sessionContinuations: [UUID: AsyncStream<HerdrSessionUpdate>.Continuation] = [:]
    var sessionConnection: HerdrConnectionState = .connecting
    var currentSession: HerdrSession?
    var sessionRunTask: Task<Void, Never>?
    var sessionEventTask: Task<Void, Never>?
    var sessionEventConnection: HerdrEventConnection?
    var subscribedPaneIDs: Set<PaneID> = []
    var sessionReconnectReason: String?
    var sessionRefreshTask: Task<Void, Never>?
    public private(set) var protocolVersion: UInt?

    public var capabilities: HerdrCapabilities? {
        protocolVersion.map(HerdrCapabilities.init(protocolVersion:))
    }

    public init(endpointProvider: any HerdrEndpointProvider) {
        self.endpointProvider = endpointProvider
        sessionObservationTiming = .production
    }

    public init(socketURL: URL) {
        endpointProvider = HerdrStaticEndpoint(url: socketURL)
        sessionObservationTiming = .production
    }

    init(
        endpointProvider: any HerdrEndpointProvider,
        sessionObservationTiming: HerdrSessionObservationTiming
    ) {
        self.endpointProvider = endpointProvider
        self.sessionObservationTiming = sessionObservationTiming
    }

    init(
        socketURL: URL,
        sessionObservationTiming: HerdrSessionObservationTiming
    ) {
        endpointProvider = HerdrStaticEndpoint(url: socketURL)
        self.sessionObservationTiming = sessionObservationTiming
    }

    deinit {
        sessionRunTask?.cancel()
        sessionEventTask?.cancel()
        sessionEventConnection?.cancel()
        sessionRefreshTask?.cancel()
    }

    public nonisolated var server: HerdrServerService { .init(client: self) }
    public nonisolated var notifications: HerdrNotificationService { .init(client: self) }
    public nonisolated var windowTitles: HerdrWindowTitleService { .init(client: self) }
    public nonisolated var sessions: HerdrSessionService { .init(client: self) }
    public nonisolated var workspaces: HerdrWorkspaceService { .init(client: self) }
    public nonisolated var worktrees: HerdrWorktreeService { .init(client: self) }
    public nonisolated var tabs: HerdrTabService { .init(client: self) }
    public nonisolated var panes: HerdrPaneService { .init(client: self) }
    public nonisolated var layouts: HerdrLayoutService { .init(client: self) }
    public nonisolated var agents: HerdrAgentService { .init(client: self) }
    public nonisolated var events: HerdrEventsService { .init(client: self) }
    public nonisolated var integrations: HerdrIntegrationService { .init(client: self) }
    public nonisolated var plugins: HerdrPluginService { .init(client: self) }

    public func send<Request: HerdrRequest>(_ request: Request) async throws -> Request.Response {
        try await requireAvailability(request.availability, feature: request.method.rawValue)
        let resultData = try await requestData(
            method: request.method,
            paramsData: encoder.encode(request.params)
        )
        return try decoder.decode(Request.Response.self, from: resultData)
    }

    public func rawRequest(
        method: String,
        params: HerdrJSONValue = .object([:])
    ) async throws -> HerdrJSONValue {
        if let knownMethod = HerdrMethod(rawValue: method) {
            try await requireAvailability(
                knownMethod.availability,
                feature: knownMethod.rawValue
            )
        }
        return try await request(
            method: method,
            params: params,
            response: HerdrJSONValue.self
        )
    }

    func request<Params: Encodable & Sendable, Response: Decodable & Sendable>(
        method: HerdrMethod,
        params: Params,
        response: Response.Type
    ) async throws -> Response {
        try await requireAvailability(method.availability, feature: method.rawValue)
        return try await request(
            method: method.rawValue,
            params: params,
            response: response
        )
    }

    func request<Params: Encodable & Sendable, Response: Decodable & Sendable>(
        method: String,
        params: Params,
        response: Response.Type
    ) async throws -> Response {
        let resultData = try await requestData(
            method: method,
            paramsData: encoder.encode(params)
        )
        return try decoder.decode(Response.self, from: resultData)
    }

    func requestData(method: HerdrMethod, paramsData: Data) async throws -> Data {
        try await requestData(method: method.rawValue, paramsData: paramsData)
    }

    func requestData(method: String, paramsData: Data) async throws -> Data {
        let socketURL = try await endpointProvider.socketURL()
        let operation = HerdrSocketTransport(socketURL: socketURL)
            .makeRequestOperation(method: method, paramsData: paramsData)
        return try await withTaskCancellationHandler {
            try await Task.detached {
                try operation.run()
            }.value
        } onCancel: {
            operation.cancel()
        }
    }

    func makeEventConnection(
        filters: [HerdrEventFilter]
    ) async throws -> HerdrEventConnection {
        for filter in filters {
            if let availability = HerdrSchemaCatalog.subscriptionAvailability[filter.type] {
                try await requireAvailability(availability, feature: filter.type)
            }
        }
        let socketURL = try await endpointProvider.socketURL()
        return try HerdrSocketTransport(socketURL: socketURL)
            .openSubscription(filters: filters)
    }

    public func openGraphicsStream(
        paneID: PaneID
    ) async throws -> HerdrPaneGraphicsStream {
        try await requireAvailability(
            HerdrMethod.paneGraphicsStream.availability,
            feature: HerdrMethod.paneGraphicsStream.rawValue
        )
        let socketURL = try await endpointProvider.socketURL()
        return try HerdrSocketTransport(socketURL: socketURL)
            .openGraphicsStream(paneID: paneID)
    }

    func registerServer(version: String, protocolVersion: UInt) throws {
        try validateCompatibility(version: version, protocolVersion: protocolVersion)
        self.protocolVersion = protocolVersion
    }

    private func requireAvailability(
        _ availability: HerdrProtocolAvailability,
        feature: String
    ) async throws {
        let requiresNegotiation =
            availability.introduced > HerdrProtocolMetadata.minimumSupportedProtocol
                || availability.obsoleted != nil
        if protocolVersion == nil, requiresNegotiation {
            try await probeServerCompatibility()
        }
        guard let protocolVersion else { return }
        if Int(protocolVersion) < availability.introduced {
            throw HerdrCompatibilityError.featureUnavailable(
                feature: feature,
                introduced: availability.introduced,
                actual: protocolVersion
            )
        }
        if let obsoleted = availability.obsoleted,
           Int(protocolVersion) >= obsoleted {
            throw HerdrCompatibilityError.featureObsoleted(
                feature: feature,
                obsoleted: obsoleted,
                actual: protocolVersion
            )
        }
    }

    private func probeServerCompatibility() async throws {
        let resultData = try await requestData(
            method: HerdrMethod.ping.rawValue,
            paramsData: encoder.encode(HerdrEmptyParameters())
        )
        let status = try decoder.decode(HerdrServerStatus.self, from: resultData)
        try registerServer(
            version: status.version,
            protocolVersion: status.protocolVersion
        )
    }
}
