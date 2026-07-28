import Foundation
import HerdrSDK
import SheepDomain

public protocol GitStatusProvider: Sendable {
    func summary(for directory: URL) async -> GitSummary?
}
