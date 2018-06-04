//
//  AnimeListViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import Foundation
import RxSwift
import RxCocoa

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
  
  let cellIdentifier = AnimeListTableViewCell.reuseIdentifier
  private let dependencies: Dependencies
  private let disposeBag = DisposeBag()
  private var networkRequestSubscription: Disposable?
  private var currentSearchText: String?
  private var canLoadMorePages = true {
    didSet {
      canLoadMorePagesSubject.onNext(canLoadMorePages)
    }
  }
  private var defaultModeCellViewModels: [AnimeCellViewModel] = []
  private var state: State = .initial {
    didSet {
      stateSubject.onNext(state)
    }
  }
  private(set) var cellViewModels = BehaviorRelay<[AnimeCellViewModel]>(value: [])
  
  var paginationLimit = Constants.defaultPaginationLimit
  let canLoadMorePagesSubject = BehaviorSubject<Bool>(value: true)
  let stateSubject = BehaviorSubject<State>(value: .initial)
  
  var mode: Mode = .default {
    didSet {
      if oldValue != mode {
        configureFor(mode: mode)
      }
    }
  }
  
  var hasData: Bool {
    return !cellViewModels.value.isEmpty
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
    self.networkRequestSubscription?.dispose()
    state = .loadingStarted
    
    let onNext: (AnimeListResponse) -> Void = { animeListResponse in
      self.state = .loadingFinsihed
      let newItems = self.createViewModels(from: animeListResponse.animeList)
      self.canLoadMorePages = newItems.count >= self.paginationLimit
      self.cellViewModels.accept(newItems)
      self.state = .uiReloadNeeded
    }
    
    let onError: (Error) -> Void = { error in
      self.state = .loadingFinsihed
      self.state = .error(error)
    }
    
    switch mode {
    case .default:
      let networkRequestSubscription = dependencies.animeListService.animeList(limit: paginationLimit, offset: 0)
              .subscribe(onNext: onNext, onError: onError)
      networkRequestSubscription.disposed(by: disposeBag)
      self.networkRequestSubscription = networkRequestSubscription
    case .searching:
      if let searchText = currentSearchText {
        let networkRequestSubscription = dependencies.animeListService.animeListSearch(text: searchText,
                                                                                       limit: paginationLimit, offset: 0)
          .subscribe(onNext: onNext, onError: onError)
        networkRequestSubscription.disposed(by: disposeBag)
        self.networkRequestSubscription = networkRequestSubscription
      } else {
        state = .loadingFinsihed
      }
    }
  }
  
  private func loadAnimeListNextPage() {
    self.networkRequestSubscription?.dispose()
    let offset = cellViewModels.value.count
    state = .loadingStarted
    
    let onNext: (AnimeListResponse) -> Void = { animeListResponse in
      self.state = .loadingFinsihed
      let newItems = self.createViewModels(from: animeListResponse.animeList)
      self.cellViewModels.accept(self.cellViewModels.value + newItems)
      self.canLoadMorePages = newItems.count >= self.paginationLimit
      self.state = .uiReloadNeeded
    }
    
    let onError: (Error) -> Void = { error in
      self.state = .loadingFinsihed
      self.state = .error(error)
    }
    
    switch mode {
    case .default:
      let networkRequestSubscription = dependencies.animeListService.animeList(limit: paginationLimit, offset: offset)
        .subscribe(onNext: onNext, onError: onError)
      networkRequestSubscription.disposed(by: disposeBag)
      self.networkRequestSubscription = networkRequestSubscription
    case .searching:
      if let searchText = currentSearchText {
        let networkRequestSubscription = dependencies.animeListService.animeListSearch(text: searchText,
                                                                                       limit: paginationLimit, offset: offset)
          .subscribe(onNext: onNext, onError: onError)
        networkRequestSubscription.disposed(by: disposeBag)
        self.networkRequestSubscription = networkRequestSubscription
      } else {
        state = .loadingFinsihed
      }
    }
  }
  
  // MARK: - Search
  
  private func configureFor(mode: Mode) {
    switch mode {
    case .searching:
      networkRequestSubscription?.dispose()
      defaultModeCellViewModels = cellViewModels.value
      cellViewModels.accept([])
    case .default:
      networkRequestSubscription?.dispose()
      cellViewModels.accept(defaultModeCellViewModels)
      defaultModeCellViewModels.removeAll()
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
