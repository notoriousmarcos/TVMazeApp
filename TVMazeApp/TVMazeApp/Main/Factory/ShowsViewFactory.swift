//
//  ShowsViewFactory.swift
//  TVMazeApp
//
//  Created by marcos.brito on 05/09/21.
//

import Foundation
import SwiftUI

protocol ShowsViewFactoryProtocol {
    associatedtype Model: ShowsViewModelProtocol
    func make() -> ShowsView<Model>
}

struct ShowsViewFactory: ShowsViewFactoryProtocol {

    let fetchShowsByPageUseCase: FetchShowByPageUseCase

    init(fetchShowsByPageUseCase: FetchShowByPageUseCase) {
        self.fetchShowsByPageUseCase = fetchShowsByPageUseCase
    }

    func make() -> ShowsView<ShowsViewModel> {
        let viewModel = ShowsViewModel(
            fetchShowsByPage: fetchShowsByPageUseCase.execute(page:)
        )
        return ShowsView(viewModel: viewModel)
    }
}
