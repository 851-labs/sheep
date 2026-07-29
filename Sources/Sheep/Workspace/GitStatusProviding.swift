import Foundation

public protocol GitStatusProvider: Sendable {
    func summary(for directory: URL) async -> GitSummary?
}
