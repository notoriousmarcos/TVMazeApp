//
//  ShowsViewFactory.swift
//  TVMazeApp
//
//  Created by marcos.brito on 05/09/21.
//

import Foundation
import SwiftUI

struct ShowsViewFactory {

    let fetchShowsByPageUseCase: FetchShowByPageUseCase
    let fetchShowsByIdUseCase: FetchShowByIdUseCase

    init(
        fetchShowsByPageUseCase: FetchShowByPageUseCase,
        fetchShowsByIdUseCase: FetchShowByIdUseCase
    ) {
        self.fetchShowsByPageUseCase = fetchShowsByPageUseCase
        self.fetchShowsByIdUseCase = fetchShowsByIdUseCase
    }

    func make() -> some View {
        let viewModel = ShowsViewModel(
            fetchShowsByPage: fetchShowsByPageUseCase.execute(page:),
            fetchShowById: fetchShowsByIdUseCase.execute(id:)
        )
        return ShowsView(viewModel: viewModel)
    }
}
