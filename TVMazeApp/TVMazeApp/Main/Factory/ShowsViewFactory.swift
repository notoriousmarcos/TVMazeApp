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

    init(fetchShowsByPageUseCase: FetchShowByPageUseCase) {
        self.fetchShowsByPageUseCase = fetchShowsByPageUseCase
    }

    func make() -> some View {
        let viewModel = ShowsViewModel(
            fetchShowsByPage: fetchShowsByPageUseCase.execute(page:)
        )
        return ShowsView(viewModel: viewModel)
    }
}
