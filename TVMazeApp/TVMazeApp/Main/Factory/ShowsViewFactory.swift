//
//  ShowsViewFactory.swift
//  TVMazeApp
//
//  Created by marcos.brito on 05/09/21.
//

import Foundation
import SwiftUI

protocol ShowsViewFactoryProtocol {
    associatedtype ShowsViewModel: ShowsViewModelProtocol
    associatedtype ShowDetailViewModel: ShowDetailViewModelProtocol
    associatedtype SomeView: View
    typealias OpenShowAction = (Show) -> SomeView
    func make(openShowAction: @escaping OpenShowAction) -> ShowsView<ShowsViewModel, ShowDetailViewModel>
}

struct ShowsViewFactory: ShowsViewFactoryProtocol {
    typealias SomeView = ShowDetailView<ShowDetailViewModel>

    let fetchShowsByPageUseCase: FetchShowByPageUseCase

    init(fetchShowsByPageUseCase: FetchShowByPageUseCase) {
        self.fetchShowsByPageUseCase = fetchShowsByPageUseCase
    }

    func make(openShowAction: @escaping OpenShowAction) -> ShowsView<ShowsViewModel, ShowDetailViewModel> {
        let viewModel = ShowsViewModel(
            fetchShowsByPage: fetchShowsByPageUseCase.execute(page:)
        )
        return ShowsView<ShowsViewModel, ShowDetailViewModel>(
            viewModel: viewModel,
            openShow: openShowAction
        )
    }
}
