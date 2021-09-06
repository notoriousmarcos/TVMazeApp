//
//  TVMazeAppApp.swift
//  TVMazeApp
//
//  Created by marcos.brito on 01/09/21.
//

import SwiftUI

class Main {
    static var shared = Main()

    private let fetchShowsById = RemoteFetchShowByIdUseCase(httpClient: NativeHTTPClient())
    private let fetchShowsBySearchTerm = RemoteFetchShowBySearchTermUseCase(httpClient: NativeHTTPClient())
    private let fetchShowsByPage = RemoteFetchShowByPageUseCase(httpClient: NativeHTTPClient())
    private let fetchEpisodesByShow = RemoteFetchEpisodesByShowUseCase(httpClient: NativeHTTPClient())

    func makeShowsView() -> some View {
        ShowsViewFactory(fetchShowsByPageUseCase: fetchShowsByPage).make()
    }
}

@main
struct TVMazeAppApp: App {
    let main = Main.shared

    var body: some Scene {
        WindowGroup {
            main.makeShowsView()
        }
    }
}
