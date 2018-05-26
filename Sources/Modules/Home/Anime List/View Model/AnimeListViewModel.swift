//
//  AnimeListViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import Foundation

private extension Constants {
  static let defaultPaginationLimit = 10
}

class AnimeListViewModel {
  
  typealias Dependencies = HasAnimeListService
  
  enum Mode {
    case searching, `default`
  }
  
  private let dependencies: Dependencies
  private var currentSearchText: String?
  private var defaultModeCellViewModels: [AnimeCellViewModel] = []
  private(set) var cellViewModels: [AnimeCellViewModel] = []
  var paginationLimit = Constants.defaultPaginationLimit
  var canLoadMorePages = true
  let dataSource = AnimeListDataSource()
  
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
  
  var onErrorEncountered: ((Error?) -> Void)?
  var onLoadingStarted: (() -> Void)?
  var onLoadingFinished: (() -> Void)?
  var onUIReloadRequested: (() -> Void)?
  
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
    DispatchQueue.main.async {
      self.onLoadingStarted?()
    }
    
    let completion: ((Response<AnimeListResponse>) -> Void) = { response in
      DispatchQueue.main.async {
        self.onLoadingFinished?()
      }
      switch response {
      case .success(let result):
        let newItems = self.createViewModels(from: result.animeList)
        self.canLoadMorePages = newItems.count >= self.paginationLimit
        self.cellViewModels = newItems
        self.dataSource.updateData(with: self)
        DispatchQueue.main.async {
          self.onUIReloadRequested?()
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self.onErrorEncountered?(error)
        }
      }
    }
    
    switch mode {
    case .default:
      dependencies.animeListService.animeList(limit: paginationLimit, offset: 0, completion: completion)
    case .searching:
      if let searchText = currentSearchText {
        dependencies.animeListService.animeListSearch(text: searchText, limit: paginationLimit, offset: 0, completion: completion)
      } else {
        onLoadingFinished?()
      }
    }
  }
  
  private func loadAnimeListNextPage() {
    let offset = cellViewModels.count
    DispatchQueue.main.async {
      self.onLoadingStarted?()
    }
    
    let completion: ((Response<AnimeListResponse>) -> Void) = { response in
      DispatchQueue.main.async {
        self.onLoadingFinished?()
      }
      switch response {
      case .success(let result):
        let newItems = self.createViewModels(from: result.animeList)
        self.cellViewModels.append(contentsOf: newItems)
        self.canLoadMorePages = newItems.count >= self.paginationLimit
        self.dataSource.updateData(with: self)
        DispatchQueue.main.async {
          self.onUIReloadRequested?()
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self.onErrorEncountered?(error)
        }
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
        onLoadingFinished?()
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
