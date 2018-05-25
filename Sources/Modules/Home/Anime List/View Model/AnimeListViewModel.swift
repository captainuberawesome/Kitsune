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
  
  // MARK: - Private
  
  func loadAnimeList() {
    onLoadingStarted?()
    dependencies.animeListService.animeList(limit: paginationLimit, offset: 0) { response in
      self.onLoadingFinished?()
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
  }
  
  func loadAnimeListNextPage() {
    let offset = cellViewModels.count
    onLoadingStarted?()
    dependencies.animeListService.animeList(limit: paginationLimit, offset: offset) { response in
      self.onLoadingFinished?()
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
