import HerdrSDK

final class AgentGroup {
    let name: String
    let agents: [AgentItem]

    init(name: String, agents: [AgentItem]) {
        self.name = name
        self.agents = agents
    }
}

final class AgentItem {
    let value: Agent

    init(_ value: Agent) {
        self.value = value
    }
}
