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
    case open(show: Show)
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
        fetchShows(page: page)
    }

    public func nextPage() {
        page += 1
        fetchShows(page: page)
    }

    public func search(_ search: String) {
        state = .loading
        findShows(search).sink { [weak self] result in
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

    public func open(show: Show) {
        state = .loading
        fetchShowById(show.id).sink { [weak self] result in
            switch result {
                case .failure(let error):
                    self?.state = .error(message: error.localizedDescription)
                case .finished:
                    break
            }
        } receiveValue: { [weak self] show in
            self?.state = .open(show: show)
        }.store(in: &cancellables)
    }

    private func fetchShows(page: Int) {
        state = .loading
        fetchShowsByPage(page).sink { [weak self] result in
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

    func testShowsViewModel_onAppearWithError_ShouldCallfetchShowError() {
        // Arrange
        let expectedStatesBehaviour: [ShowsState] = [
            .idle,
            .loading,
            .error(message: "The operation couldn’t be completed. (TVMazeApp.DomainError error 1.)")
        ]
        var fetchByPageCount = 0
        var statesBehaviour: [ShowsState] = []
        let sut = ShowsViewModel(findShows: { show in
            self.makeSuccessPublisher(forValue: [MockEntities.show])
        }, fetchShowsByPage: { page in
            fetchByPageCount += 1
            XCTAssertEqual(page, 0)
            return self.makeFailPublisher(forError: .fetchError)
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

    func testShowsViewModel_nextPage_ShouldCallfetchShows() {
        // Arrange
        let expectedStatesBehaviour: [ShowsState] = [
            .idle,
            .loading,
            .loaded(shows: [MockEntities.show]),
            .loading,
            .loaded(shows: [MockEntities.show])
        ]
        var fetchByPageBehaviour: [Int] = []
        var statesBehaviour: [ShowsState] = []
        let sut = ShowsViewModel(findShows: { show in
            self.makeSuccessPublisher(forValue: [MockEntities.show])
        }, fetchShowsByPage: { page in
            fetchByPageBehaviour.append(page)
            return self.makeSuccessPublisher(forValue: [MockEntities.show])
        }, fetchShowById: { _ in
            self.makeSuccessPublisher(forValue: MockEntities.show)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.onAppear()
        sut.nextPage()

        // Assert
        XCTAssertEqual(fetchByPageBehaviour, [0, 1])
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        cancellable.cancel()
    }

    func testShowsViewModel_searchTerm_ShouldCallfetchShows() {
        // Arrange
        let expectedStatesBehaviour: [ShowsState] = [
            .idle,
            .loading,
            .loaded(shows: [MockEntities.show])
        ]
        var findBehaviour: [String] = []
        var statesBehaviour: [ShowsState] = []
        let sut = ShowsViewModel(findShows: { searchTerm in
            findBehaviour.append(searchTerm)
            return self.makeSuccessPublisher(forValue: [MockEntities.show])
        }, fetchShowsByPage: { _ in
            return self.makeSuccessPublisher(forValue: [])
        }, fetchShowById: { _ in
            self.makeSuccessPublisher(forValue: MockEntities.show)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.search("search")

        // Assert
        XCTAssertEqual(findBehaviour, ["search"])
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        cancellable.cancel()
    }

    func testShowsViewModel_open_ShouldCallfetchShow() {
        // Arrange
        let expectedStatesBehaviour: [ShowsState] = [
            .idle,
            .loading,
            .open(show: MockEntities.show)
        ]
        var openBehaviour: [Int] = []
        var statesBehaviour: [ShowsState] = []
        let sut = ShowsViewModel(findShows: { _ in
            return self.makeSuccessPublisher(forValue: [MockEntities.show])
        }, fetchShowsByPage: { _ in
            return self.makeSuccessPublisher(forValue: [])
        }, fetchShowById: { showId in
            openBehaviour.append(showId)
            return self.makeSuccessPublisher(forValue: MockEntities.show)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.open(show: MockEntities.show)

        // Assert
        XCTAssertEqual(openBehaviour, [1])
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
