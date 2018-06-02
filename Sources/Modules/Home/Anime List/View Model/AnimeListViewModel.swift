//
//  AnimeListViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import Foundation
import RxSwift

private extension Constants {
  static let defaultPaginationLimit = 10
}

class AnimeListViewModel {
  
  typealias Dependencies = HasAnimeListService
  
  enum Mode {
    case searching, `default`
  }
  
  enum State {
    case initial, loadingStarted, loadingFinsihed, error(Error?), uiReloadNeeded
  }
  
  private let dependencies: Dependencies
  private var currentSearchText: String?
  private var _state: State = .initial
  private var _error: Error?
  private var defaultModeCellViewModels: [AnimeCellViewModel] = []
  private var state: State = .initial {
    didSet {
      stateSubject.onNext(state)
    }
  }
  private(set) var cellViewModels: [AnimeCellViewModel] = []
  
  var paginationLimit = Constants.defaultPaginationLimit
  var canLoadMorePages = true
  let dataSource = AnimeListDataSource()
  let stateSubject = BehaviorSubject<State>(value: .initial)
  
  var mode: Mode = .default {
    didSet {
      if oldValue != mode {
        configureFor(mode: mode)
      }
    }
  }
  
  var hasData: Bool {
    return !cellViewModels.isEmpty
  }
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Public
  
  func reloadData() {
    loadAnimeList()
  }
  
  func loadNextPage() {
    loadAnimeListNextPage()
  }
  
  func search(forText text: String) {
    currentSearchText = text
    loadAnimeList()
  }
  
  // MARK: - Private
  
  private func loadAnimeList() {
    self.state = .loadingStarted
    
    let completion: ((Response<AnimeListResponse>) -> Void) = { response in
      self.state = .loadingFinsihed
      switch response {
      case .success(let result):
        let newItems = self.createViewModels(from: result.animeList)
        self.canLoadMorePages = newItems.count >= self.paginationLimit
        self.cellViewModels = newItems
        self.dataSource.updateData(with: self)
        self.state = .uiReloadNeeded
      case .failure(let error):
        self.state = .error(error)
      }
    }
    
    switch mode {
    case .default:
      dependencies.animeListService.animeList(limit: paginationLimit, offset: 0, completion: completion)
    case .searching:
      if let searchText = currentSearchText {
        dependencies.animeListService.animeListSearch(text: searchText, limit: paginationLimit, offset: 0, completion: completion)
      } else {
        state = .loadingFinsihed
      }
    }
  }
  
  private func loadAnimeListNextPage() {
    let offset = cellViewModels.count
    state = .loadingStarted
    
    let completion: ((Response<AnimeListResponse>) -> Void) = { response in
      self.state = .loadingFinsihed
      switch response {
      case .success(let result):
        let newItems = self.createViewModels(from: result.animeList)
        self.cellViewModels.append(contentsOf: newItems)
        self.canLoadMorePages = newItems.count >= self.paginationLimit
        self.dataSource.updateData(with: self)
        self.state = .uiReloadNeeded
      case .failure(let error):
        self.state = .error(error)
      }
    }
    
    switch mode {
    case .default:
      dependencies.animeListService.animeList(limit: paginationLimit, offset: offset, completion: completion)
    case .searching:
      if let searchText = currentSearchText {
        dependencies.animeListService.animeListSearch(text: searchText, limit: paginationLimit, offset: offset,
                                                      completion: completion)
      } else {
        state = .loadingFinsihed
      }
    }
  }
  
  // MARK: - Search
  
  private func configureFor(mode: Mode) {
    switch mode {
    case .searching:
      defaultModeCellViewModels = cellViewModels
      cellViewModels = []
      dataSource.updateData(with: self)
    case .default:
      cellViewModels = defaultModeCellViewModels
      dataSource.updateData(with: self)
      defaultModeCellViewModels = []
      currentSearchText = nil
    }
  }
  
  // MARK: - AnimeCellViewModel
  
  private func createViewModels(from array: [Anime]) -> [AnimeCellViewModel] {
    return array.compactMap {
      let reuseIdentifier = AnimeListTableViewCell.reuseIdentifier
      let viewModel = AnimeCellViewModel(anime: $0, cellReuseIdentifier: reuseIdentifier)
      return viewModel
    }
  }
}
