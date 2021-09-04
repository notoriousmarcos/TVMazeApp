//
//  RemoteFetchEpisodesByShowUseCaseTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 03/09/21.
//

import XCTest
@testable import TVMazeApp

class RemoteFetchEpisodesByShowUseCaseTests: XCTestCase {

    let mockClient = MockHTTPClient()

    func testRemoteFetchEpisodesByShowUseCase_executeWithValidData_ShouldReturnEpisodes() {
        // Arrange
        mockClient.result = [MockEntities.episode]
        let sut = RemoteFetchEpisodesByShowUseCase(httpClient: mockClient)

        // Act
        let cancellable = sut.execute(show: MockEntities.show).sink { result in
            switch result {
                case .failure:
                    XCTFail("Should Not Fail.")
                case .finished:
                    break
            }
        } receiveValue: { shows in
            // Assert
            XCTAssertEqual(shows, [MockEntities.episode])
        }

        cancellable.cancel()
    }

    func testRemoteFetchEpisodesByShowUseCase_executeWithBadRequest_ShouldReturnFetchError() {
        // Arrange
        mockClient.error = HTTPError.badRequest
        let sut = RemoteFetchEpisodesByShowUseCase(httpClient: mockClient)

        // Act
        let cancellable = sut.execute(show: MockEntities.show).sink { result in
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
