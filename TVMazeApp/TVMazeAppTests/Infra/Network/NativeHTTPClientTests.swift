//
//  NativeHTTPClientTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 03/09/21.
//

import Combine
import XCTest
@testable import TVMazeApp

class MockURLProtocol: URLProtocol {

    static var requestHandler: ((URLRequest) -> (URLResponse, Data?, Error?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let (response, data, error) = Self.requestHandler?(request) else {
            XCTFail("RequestHandler Shouldn't be nil")
            return
        }

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        //
    }
}

class NativeHTTPClientTests: XCTestCase {

    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()

    func testNativeHTTPClient_init_ShouldRetainProperties() {
        // Arrange
        let sut = NativeHTTPClient(session: session)

        // Assert
        XCTAssertNotNil(sut.session)
    }

    func testNativeHTTPClient_makeRequest_ShouldReturnASuccess() {
        // Arrange
        let sut = NativeHTTPClient(session: session)
        let validData = "{\"response\": \"value\"}".data(using: .utf8)!
        let exp = expectation(description: "Waiting for Request")

        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), validData, nil)
        }

        let publisher: AnyPublisher<[String: String], HTTPError> = sut.dispatch(
            request: URLRequest(
                url: URL(string: "http://google.com")!
            )
        )
        let cancellable = publisher.sink { result in
            switch result {
                case .failure:
                    XCTFail("Shuld not fail.")
                case .finished:
                    break
            }
            exp.fulfill()
        } receiveValue: { response in
            XCTAssertEqual(response["response"], "value")
        }

        wait(for: [exp], timeout: 1)
        cancellable.cancel()
    }

    func testNativeHTTPClient_makeRequest_ShouldReturnUnknown() {
        // Arrange
        let sut = NativeHTTPClient(session: session)
        let invalidJSONData = "{\"response\": \"value\"".data(using: .utf8)!
        let exp = expectation(description: "Waiting for Request")

        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), invalidJSONData, nil)
        }

        let publisher: AnyPublisher<[String: String], HTTPError> = sut.dispatch(
            request: URLRequest(
                url: URL(string: "http://google.com")!
            )
        )
        let cancellable = publisher.sink { result in
            switch result {
                case .failure(let error):
                    XCTAssertEqual(error, .unknown)
                case .finished:
                    break
            }
            exp.fulfill()
        } receiveValue: { _ in }

        wait(for: [exp], timeout: 1)
        cancellable.cancel()
    }

    func testNativeHTTPClient_makeGetRequest_ShouldReturnUnauthorized() {
        // Arrange
        let sut = NativeHTTPClient(session: session)
        let exp = expectation(description: "Waiting for Request")

        MockURLProtocol.requestHandler = { request in
            return (self.createErrorResponseForRequest(request, code: 401), nil, nil)
        }

        let publisher: AnyPublisher<[String: String], HTTPError> = sut.dispatch(
            request: URLRequest(
                url: URL(string: "http://google.com")!
            )
        )
        let cancellable = publisher.sink { result in
            switch result {
                case .failure(let error):
                    XCTAssertEqual(error, .unauthorized)
                case .finished:
                    break
            }
            exp.fulfill()
        } receiveValue: { _ in }

        wait(for: [exp], timeout: 1)
        cancellable.cancel()
    }

    func testNativeHTTPClient_makeInvalidRequest_ShouldReturnUnknown() {
        // Arrange
        let sut = NativeHTTPClient(session: session)
        let validData = Data()
        let exp = expectation(description: "Waiting for Request")

        MockURLProtocol.requestHandler = { request in
            return (self.createErrorResponseForRequest(request, code: -1), validData, nil)
        }

        let publisher: AnyPublisher<[String: String], HTTPError> = sut.dispatch(
            request: URLRequest(
                url: URL(string: "http://google.com")!
            )
        )
        let cancellable = publisher.sink { result in
            switch result {
                case .failure(let error):
                    XCTAssertEqual(error, .unknown)
                case .finished:
                    break
            }
            exp.fulfill()
        } receiveValue: { _ in }

        wait(for: [exp], timeout: 1)
        cancellable.cancel()
    }

    private func createErrorResponseForRequest(_ request: URLRequest, code: Int) -> URLResponse {
        HTTPURLResponse(url: request.url!,
                        statusCode: code,
                        httpVersion: nil,
                        headerFields: request.allHTTPHeaderFields)!
    }
}
