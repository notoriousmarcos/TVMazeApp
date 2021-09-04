//
//  RemoteFetchShowByPageUseCaseTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 03/09/21.
//

import XCTest
@testable import TVMazeApp

class RemoteFetchShowByPageUseCaseTests: XCTestCase {

    let mockClient = MockHTTPClient()

    func testRemoteFetchShowByPageUseCase_executeWithValidData_ShouldReturnShows() {
        // Arrange
        mockClient.result = [MockShow.valid]
        let sut = RemoteFetchShowByPageUseCase(httpClient: mockClient)

        // Act
        let cancellable = sut.execute(page: 1).sink { result in
            switch result {
                case .failure:
                    XCTFail("Should Not Fail.")
                case .finished:
                    break
            }
        } receiveValue: { shows in
            // Assert
            XCTAssertEqual(shows, [MockShow.valid])
        }

        cancellable.cancel()
    }

    func testRemoteFetchShowByPageUseCase_executeWithBadRequest_ShouldReturnFetchError() {
        // Arrange
        mockClient.error = HTTPError.badRequest
        let sut = RemoteFetchShowByPageUseCase(httpClient: mockClient)

        // Act
        let cancellable = sut.execute(page: 1).sink { result in
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
