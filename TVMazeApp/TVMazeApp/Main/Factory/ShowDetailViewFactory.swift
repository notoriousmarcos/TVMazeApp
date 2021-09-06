//
//  ShowDetailViewFactory.swift
//  TVMazeApp
//
//  Created by marcos.brito on 06/09/21.
//

import Foundation
import SwiftUI

protocol ShowDetailViewFactoryProtocol {
    associatedtype Model: ShowDetailViewModelProtocol
    func make(_ show: Show) -> ShowDetailView<Model>
}

struct ShowDetailViewFactory: ShowDetailViewFactoryProtocol {

    let fetchShowsByIdUseCase: FetchShowByIdUseCase
    let fetchpisodesByShowUseCase: FetchEpisodesByShowUseCase

    init(
        fetchShowsByIdUseCase: FetchShowByIdUseCase,
        fetchpisodesByShowUseCase: FetchEpisodesByShowUseCase
    ) {
        self.fetchShowsByIdUseCase = fetchShowsByIdUseCase
        self.fetchpisodesByShowUseCase = fetchpisodesByShowUseCase
    }

    func make(_ show: Show) -> ShowDetailView<ShowDetailViewModel> {
        let viewModel = ShowDetailViewModel(
            show: show,
            fetchShowById: fetchShowsByIdUseCase.execute(id:),
            fetchEpisodesByShow: fetchpisodesByShowUseCase.execute(show:))
        return ShowDetailView(viewModel: viewModel)
    }
}
