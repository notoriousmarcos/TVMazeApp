//
//  RemoteFetchShowByIdUseCaseIntegrationTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 04/09/21.
//

import XCTest
import CoreData
@testable import TVMazeApp

class RemoteFetchShowByIdUseCaseIntegrationTests: XCTestCase {

    func testRemoteFetchShowByIdUseCase_fetch_ShouldReceiveShow() {
        // Arrange
        let httpClient = NativeHTTPClient()
        let sut = RemoteFetchShowByIdUseCase(httpClient: httpClient)

        let exp = expectation(description: "Waiting request")
        // Act
        let cancellable = sut.execute(id: 1).sink { _ in
            exp.fulfill()
        } receiveValue: { show in
            XCTAssertNotNil(show)
        }

        wait(for: [exp], timeout: 5)
        cancellable.cancel()
    }
}
