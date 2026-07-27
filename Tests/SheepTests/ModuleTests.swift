import XCTest
@testable import SheepDomain
@testable import SheepApplication
@testable import SheepInfrastructure

final class ModuleTests: XCTestCase {
    func testModulesAreLinked() {
        XCTAssertEqual(SheepDomainModule.name, "SheepDomain")
        XCTAssertEqual(SheepApplicationModule.name, "SheepApplication")
        XCTAssertEqual(SheepInfrastructureModule.name, "SheepInfrastructure")
    }
}

