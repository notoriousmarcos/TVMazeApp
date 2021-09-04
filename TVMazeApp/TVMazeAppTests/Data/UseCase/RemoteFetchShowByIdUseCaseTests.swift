//
//  RemoteFetchShowByIdUseCaseTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 03/09/21.
//

import XCTest
@testable import TVMazeApp

class RemoteFetchShowByIdUseCaseTests: XCTestCase {

    let mockClient = MockHTTPClient()

    func testRemoteFetchShowByIdUseCase_executeWithValidData_ShouldReturnShow() {
        // Arrange
        mockClient.result = MockShow.valid
        let sut = RemoteFetchShowByIdUseCase(httpClient: mockClient)

        // Act
        let cancellable = sut.execute(id: 1)
            .sink { result in
            switch result {
                case .failure:
                    XCTFail("Should Not Fail.")
                case .finished:
                    break
            }
        } receiveValue: { show in
            // Assert
            XCTAssertEqual(show, MockShow.valid)
        }

        cancellable.cancel()
    }

    func testRemoteFetchShowByIdUseCase_executeWithBadRequest_ShouldReturnFetchError() {
        // Arrange
        mockClient.error = HTTPError.badRequest
        let sut = RemoteFetchShowByIdUseCase(httpClient: mockClient)

        // Act
        let cancellable = sut.execute(id: 1).sink { result in
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
