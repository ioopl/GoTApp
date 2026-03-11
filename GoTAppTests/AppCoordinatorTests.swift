import SwiftUI
import XCTest

@testable import GoTApp

final class AppCoordinatorTests: XCTestCase {
    var sut: AppCoordinator!

    @MainActor
    override func setUp() {
        super.setUp()
        sut = AppCoordinator()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    @MainActor
    func testStart_InitialState() {
        sut.start()
        XCTAssertTrue(sut.isAuthenticated)
        XCTAssertNil(sut.errorMessage)
    }

    @MainActor
    func testShowError_UpdatesState() {
        sut.showError(message: "Test Error")
        XCTAssertFalse(sut.isAuthenticated)
        XCTAssertEqual(sut.errorMessage, "Test Error")
    }

    @MainActor
    func testRetry_ResetsState() {
        sut.showError(message: "Test Error")
        sut.retry()
        XCTAssertTrue(sut.isAuthenticated)
        XCTAssertNil(sut.errorMessage)
    }

    @MainActor
    func testShowDetail_AppendsToPath() {
        let character = Character(
            name: "Test", gender: nil, culture: nil, born: nil, died: nil, titles: nil,
            aliases: nil, tvSeries: nil, playedBy: nil)
        sut.showDetail(for: character)
        XCTAssertEqual(sut.path.count, 1)
    }
}
