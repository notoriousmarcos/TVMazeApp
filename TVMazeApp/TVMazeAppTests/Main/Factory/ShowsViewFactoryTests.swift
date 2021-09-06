//
//  ShowsViewFactoryTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 05/09/21.
//

import Combine
import SwiftUI
import XCTest
@testable import TVMazeApp

class ShowsViewFactoryTests: XCTestCase {

    func testShowsViewFactory_factory_ShouldReturnShowsView() {
        // Arrange
        let sut = ShowsViewFactory(
            fetchShowsByPageUseCase: RemoteFetchShowByPageUseCase(httpClient: NativeHTTPClient()))

        // Act
        let view = sut.make(openShowAction: { show in
            ShowDetailView(
                viewModel: ShowDetailViewModel(
                    show: show,
                    fetchShowById: { _ -> AnyPublisher<Show, DomainError> in
                        return Mocks.makeSuccessPublisher(forValue: Mocks.show)
                    },
                    fetchEpisodesByShow: { _ -> AnyPublisher<[Episode], DomainError> in
                        return Mocks.makeSuccessPublisher(forValue: [Mocks.episode])
                    }
                )
            )
        })

        // Assert
        XCTAssertNotNil(view)
    }

}
