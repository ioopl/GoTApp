import Foundation

/**
 The MockURLProtocol Hijacks every request the NetworkManager tries to make.
 */
class MockURLProtocol: URLProtocol {
    // Hold mock responses or errors mapped by Endpoint URL
    static var stubResponseData: Data?
    static var stubHTTPResponse: HTTPURLResponse?
    static var stubError: Error?

    /**
     canInit: The system asks: "Do you want to handle this request?" We return true, so it never goes to the real API.
     */
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    /**
     canonicalRequest: This is for normalizing the request e.g. adding default headers. We just return it as is.
     */
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    /**
     startLoading: This is where we "fake" the server. We manually send back the stubResponseData (e.g. "Jon Snow" JSON) and a successful HTTP response to the NetworkManager.
     */
    override func startLoading() {
        if let error = MockURLProtocol.stubError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = MockURLProtocol.stubHTTPResponse {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = MockURLProtocol.stubResponseData {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    /**
     stopLoading: Used for cleanup if a request is cancelled. Since our mock is instant, we leave it empty.
     */
    override func stopLoading() {
        //
    }
}
