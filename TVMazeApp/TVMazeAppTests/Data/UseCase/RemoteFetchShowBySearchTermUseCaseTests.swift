//
//  RemoteFetchShowBySearchTermUseCaseTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 03/09/21.
//

import XCTest
@testable import TVMazeApp

class RemoteFetchShowBySearchTermUseCaseTests: XCTestCase {

    let mockClient = MockHTTPClient()

    func testRemoteFetchShowBySearchTermUseCase_executeWithValidData_ShouldReturnShows() {
        // Arrange
        mockClient.result = [Mocks.show]
        let sut = RemoteFetchShowBySearchTermUseCase(httpClient: mockClient)

        // Act
        let cancellable = sut.execute(searchTerm: "search").sink { result in
            switch result {
                case .failure:
                    XCTFail("Should Not Fail.")
                case .finished:
                    break
            }
        } receiveValue: { shows in
            // Assert
            XCTAssertEqual(shows, [Mocks.show])
        }

        cancellable.cancel()
    }

    func testRemoteFetchShowBySearchTermUseCase_executeWithBadRequest_ShouldReturnFetchError() {
        // Arrange
        mockClient.error = HTTPError.badRequest
        let sut = RemoteFetchShowBySearchTermUseCase(httpClient: mockClient)

        // Act
        let cancellable = sut.execute(searchTerm: "search").sink { result in
            switch result {
                case .failure(let error):
                    XCTAssertEqual(error, .fetchError)
                case .finished:
                    break
            }
        } receiveValue: { _ in }

        cancellable.cancel()
    }
}
