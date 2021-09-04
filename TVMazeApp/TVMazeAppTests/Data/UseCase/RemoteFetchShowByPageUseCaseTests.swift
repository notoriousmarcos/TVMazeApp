//
//  RemoteFetchShowByPageUseCaseTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 03/09/21.
//

import XCTest
@testable import TVMazeApp

//class RemoteFetchShowByPageUseCaseTests: XCTestCase {
//
//    let url = URL(string: "https://api.shrtco.de/v2/shorten")!
//    let mockClient = MockHTTPGetClient()
//
//    func testRemoteFetchShortURLUseCase_executeWithValidData_ShouldReturnAValidShortURL() {
//        // Arrange
//        mockClient.result = .success(MockResponses.validResponse.toData())
//        let sut = RemoteFetchShortURLUseCase(url: url, httpClient: mockClient)
//
//        // Act
//        sut.execute(urlModel) { result in
//            // Assert
//            if case let .success(shortURL) = result {
//                XCTAssertEqual(shortURL, MockResponses.validShortURLModel)
//            } else {
//                XCTFail("Should receive a valid response")
//            }
//        }
//    }
//
//    func testRemoteFetchShortURLUseCase_executeWithNilData_ShouldReturnUnknownError() {
//        // Arrange
//        mockClient.result = .success(nil)
//        let sut = RemoteFetchShortURLUseCase(url: url, httpClient: mockClient)
//
//        // Act
//        sut.execute(urlModel) { result in
//            // Assert
//            if case let .failure(error) = result {
//                XCTAssertEqual(error, .unknown)
//            } else {
//                XCTFail("Should receive a unknown error")
//            }
//        }
//    }
//
//    func testRemoteFetchShortURLUseCase_executeWithInvalidData_ShouldReturnUnknownError() {
//        // Arrange
//        mockClient.result = .success(MockResponses.validResponseWithEmptyData.toData())
//        let sut = RemoteFetchShortURLUseCase(url: url, httpClient: mockClient)
//
//        // Act
//        sut.execute(urlModel) { result in
//            // Assert
//            if case let .failure(error) = result {
//                XCTAssertEqual(error, .unknown)
//            } else {
//                XCTFail("Should receive a unknown error")
//            }
//        }
//    }
//
//    func testRemoteFetchShortURLUseCase_executeWithKnownError_ShouldReturnKnownError() {
//        // Arrange
//        mockClient.result = .success(MockResponses.invalidResponseWithErrorCode(1).toData())
//        let sut = RemoteFetchShortURLUseCase(url: url, httpClient: mockClient)
//
//        // Act
//        sut.execute(urlModel) { result in
//            // Assert
//            if case let .failure(error) = result {
//                XCTAssertEqual(error, .emptyURL)
//            } else {
//                XCTFail("Should receive a emptyURL error")
//            }
//        }
//    }
//
//    func testRemoteFetchShortURLUseCase_executeWithUnknownStatusCode_ShouldReturnEmptyURL() {
//        // Arrange
//        mockClient.result = .success(MockResponses.invalidResponseWithErrorCode(-1).toData())
//        let sut = RemoteFetchShortURLUseCase(url: url, httpClient: mockClient)
//
//        // Act
//        sut.execute(urlModel) { result in
//            // Assert
//            if case let .failure(error) = result {
//                XCTAssertEqual(error, .unknown)
//            } else {
//                XCTFail("Should receive a unknown error")
//            }
//        }
//    }
//
//    func testRemoteFetchShortURLUseCase_executeWithFailRequest_ShouldReturnUnkownError() {
//        // Arrange
//        mockClient.result = .failure(.serverError)
//        let sut = RemoteFetchShortURLUseCase(url: url, httpClient: mockClient)
//
//        // Act
//        sut.execute(urlModel) { result in
//            // Assert
//            if case let .failure(error) = result {
//                XCTAssertEqual(error, .unknown)
//            } else {
//                XCTFail("Should receive a unknown error")
//            }
//        }
//    }
//
//    struct MockResponses {
//        static let validShortURLModel = ShortlyURLModel(code: "KCveN",
//                                                        shortLink: "shrtco.de/KCveN",
//                                                        fullShortLink: "https://shrtco.de/KCveN",
//                                                        shortLink2: "9qr.de/KCveN",
//                                                        fullShortLink2: "https://9qr.de/KCveN",
//                                                        shareLink: "shrtco.de/share/KCveN",
//                                                        fullShareLink: "https://shrtco.de/share/KCveN",
//                                                        originalLink: "http://example.org/very/long/link.html")
//
//        static let validResponse = FetchShortURLUseResponse(ok: true,
//                                                            error_code: nil,
//                                                            error: nil,
//                                                            result: validShortURLModel)
//
//        static let validResponseWithEmptyData = FetchShortURLUseResponse(ok: true,
//                                                                         error_code: nil,
//                                                                         error: nil,
//                                                                         result: nil)
//
//        static func invalidResponseWithErrorCode(_ code: Int) -> FetchShortURLUseResponse {
//            FetchShortURLUseResponse(ok: false,
//                                     error_code: code,
//                                     error: "",
//                                     result: nil)
//        }
//    }
//}
