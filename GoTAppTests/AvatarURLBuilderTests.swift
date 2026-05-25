import XCTest

@testable import GoTApp

final class AvatarURLBuilderTests: XCTestCase {
    func testURL_UsesDeterministicCatAvatarEndpoint() throws {
        let url = try XCTUnwrap(AvatarURLBuilder.url(for: "Arya Stark289"))
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []

        XCTAssertEqual(components.host, "robohash.org")
        XCTAssertTrue(url.absoluteString.contains("Arya%20Stark289.png"))
        XCTAssertTrue(queryItems.contains(URLQueryItem(name: "set", value: "set4")))
        XCTAssertTrue(queryItems.contains(URLQueryItem(name: "bgset", value: "bg1")))
        XCTAssertTrue(queryItems.contains(URLQueryItem(name: "size", value: "96x96")))
    }

    func testURL_EncodesPathUnsafeCharacters() throws {
        let url = try XCTUnwrap(AvatarURLBuilder.url(for: "A/B Stark 263"))

        XCTAssertTrue(url.absoluteString.contains("A%2FB%20Stark%20263"))
    }

    func testURL_IncludesCacheBusterWhenProvided() throws {
        let url = try XCTUnwrap(AvatarURLBuilder.url(for: "Arya Stark289", cacheBuster: "refresh-1"))
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))

        XCTAssertTrue(components.queryItems?.contains(URLQueryItem(name: "refresh", value: "refresh-1")) == true)
    }
}
