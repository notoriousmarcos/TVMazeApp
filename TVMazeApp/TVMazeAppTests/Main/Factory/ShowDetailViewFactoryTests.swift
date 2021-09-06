//
//  ShowDetailViewFactoryTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 06/09/21.
//

import SwiftUI
import XCTest
@testable import TVMazeApp

class ShowDetailViewFactoryTests: XCTestCase {

    func testShowDetailViewFactory_factory_ShouldReturnShowDetailView() {
        // Arrange
        let sut = ShowDetailViewFactory(
            fetchShowsByIdUseCase: RemoteFetchShowByIdUseCase(httpClient: NativeHTTPClient()),
            fetchpisodesByShowUseCase: RemoteFetchEpisodesByShowUseCase(httpClient: NativeHTTPClient()))

        // Act
        let view = sut.make(Mocks.show)

        // Assert
        XCTAssertNotNil(view)
    }

}
