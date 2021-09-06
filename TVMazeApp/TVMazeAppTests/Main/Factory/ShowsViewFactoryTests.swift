//
//  ShowsViewFactoryTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 05/09/21.
//

import SwiftUI
import XCTest
@testable import TVMazeApp

class ShowsViewFactoryTests: XCTestCase {

    func testShowsViewFactory_factory_ShouldReturnShowsView() {
        // Arrange
        let sut = ShowsViewFactory(
            fetchShowsByPageUseCase: RemoteFetchShowByPageUseCase(httpClient: NativeHTTPClient()))

        // Act
        let view = sut.make()

        // Assert
        XCTAssertNotNil(view)
    }

}
