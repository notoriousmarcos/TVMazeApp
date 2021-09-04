//
//  ShowsViewModelTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 04/09/21.
//

import Combine
import XCTest
@testable import TVMazeApp

public enum ShowsState: Equatable {
    case idle
    case loaded(shows: [Show])
    case loading
    case error(message: String)
}

public protocol ShowsViewModelProtocol: ObservableObject {
    typealias FindShows = (String) -> AnyPublisher<[Show], DomainError>
    typealias FetchShowsByPage = (Int) -> AnyPublisher<[Show], DomainError>
    typealias FetchShowById = (Int) -> AnyPublisher<Show, DomainError>

    var state: ShowsState { get }
    var page: Int { get }

    func onAppear()
    func nextPage()
    func search(_ search: String)
    func open(show: Show)
}

public final class ShowsViewModel: ShowsViewModelProtocol {

    private let findShows: FindShows
    private let fetchShowsByPage: FetchShowsByPage
    private let fetchShowById: FetchShowById
    private var cancellables = Set<AnyCancellable>()

    @Published public var state: ShowsState = .idle
    public var page: Int = 0

    public init(
        findShows: @escaping FindShows,
        fetchShowsByPage: @escaping FetchShowsByPage,
        fetchShowById: @escaping FetchShowById
    ) {
        self.findShows = findShows
        self.fetchShowsByPage = fetchShowsByPage
        self.fetchShowById = fetchShowById

    }

    public func onAppear() {
        state = .loading
        fetchShowsByPage(0).sink { [weak self] result in
            switch result {
                case .failure(let error):
                    self?.state = .error(message: error.localizedDescription)
                case .finished:
                    break
            }
        } receiveValue: { [weak self] shows in
            self?.state = .loaded(shows: shows)
        }.store(in: &cancellables)

    }
    public func nextPage() {}
    public func search(_ search: String) {}
    public func open(show: Show) {}
}

class ShowsViewModelTests: XCTestCase {

    func testShowsViewModel_onAppear_ShouldCallfetchShowsByPageZero() {
        // Arrange
        let expectedStatesBehaviour: [ShowsState] = [.idle, .loading, .loaded(shows: [MockEntities.show])]
        var fetchByPageCount = 0
        var statesBehaviour: [ShowsState] = []
        let sut = ShowsViewModel(findShows: { show in
            self.makeSuccessPublisher(forValue: [MockEntities.show])
        }, fetchShowsByPage: { page in
            fetchByPageCount += 1
            XCTAssertEqual(page, 0)
            return self.makeSuccessPublisher(forValue: [MockEntities.show])
        }, fetchShowById: { _ in
            self.makeSuccessPublisher(forValue: MockEntities.show)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.onAppear()

        // Assert
        XCTAssertEqual(fetchByPageCount, 1)
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        cancellable.cancel()
    }

    private func makeSuccessPublisher<T>(forValue value: T) -> AnyPublisher<T, DomainError> {
        return Just(value)
            .setFailureType(to: DomainError.self)
            .eraseToAnyPublisher()
    }

    private func makeFailPublisher<T>(forError error: DomainError) -> AnyPublisher<T, DomainError> {
        return Fail(error: error)
            .eraseToAnyPublisher()
    }
}
