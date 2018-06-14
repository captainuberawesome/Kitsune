//
//  AnimeViewModelTests.swift
//  KitsuneTests
//
//  Created by Daria Novodon on 14/06/2018.
//

import XCTest
import Nimble
import RxNimble
import RxSwift

@testable import Kitsune

class AnimeViewModelTests: XCTestCase {
    
  let dependency = DependencyStub()
  let failingDependency = DependencyFailureStub()
  let disposeBag = DisposeBag()
  
  func testReloadData() {
    let viewModel = AnimeListViewModel(dependencies: dependency)
    
    var mockState: ViewModelNetworkRequestingState = .initial
    viewModel.state
      .subscribe(onNext: { state in
        expect(state) == mockState
        if mockState == .initial {
          mockState = .loadingStarted
        } else {
          mockState = .loadingFinished
        }
      }, onError: { error in
        expect(error).to(beNil())
      })
      .disposed(by: disposeBag)
    
    var createdCellViewModels = false
    viewModel.cellViewModels
      .skip(1)
      .subscribe(onNext: { cellViewModels in
        createdCellViewModels = true
        expect(cellViewModels.count) == Constants.animeListArrayCount
        self.compareViewModels(cellViewModels, toAnimeArray: Constants.responseAnime)
      }, onError: { error in
        expect(error).to(beNil())
      })
      .disposed(by: disposeBag)
    
    viewModel.reloadData()
    expect(mockState) == .loadingFinished
    expect(viewModel.hasData) == true
    expect(createdCellViewModels) == true
  }
  
  func testReloadDataFail() {
    let viewModel = AnimeListViewModel(dependencies: failingDependency)
    
    var mockState: ViewModelNetworkRequestingState = .initial
    viewModel.state
      .subscribe(onNext: { state in
        expect(state) == mockState
        if mockState == .initial {
          mockState = .loadingStarted
        } else {
          mockState = .loadingFinished
        }
      }, onError: { error in
        expect(error.localizedDescription) == Constants.dependencyStubError.localizedDescription
      })
      .disposed(by: disposeBag)
    
    viewModel.reloadData()
    expect(mockState) == .loadingFinished
    expect(viewModel.hasData) == false
  }
  
  func testSearchText() {
    let viewModel = AnimeListViewModel(dependencies: dependency)
    viewModel.mode = .searching
    
    var mockState: ViewModelNetworkRequestingState = .initial
    viewModel.state
      .subscribe(onNext: { state in
        expect(state) == mockState
        if mockState == .initial {
          mockState = .loadingStarted
        } else {
          mockState = .loadingFinished
        }
      }, onError: { error in
        expect(error).to(beNil())
      })
      .disposed(by: disposeBag)
    
    var createdCellViewModels = false
    viewModel.cellViewModels
      .skip(1)
      .subscribe(onNext: { cellViewModels in
        createdCellViewModels = true
        expect(cellViewModels.count) == Constants.animeListArrayCount
        self.compareViewModels(cellViewModels, toAnimeArray: Constants.responseAnimeSearch)
      }, onError: { error in
        expect(error).to(beNil())
      })
      .disposed(by: disposeBag)
    
    viewModel.search(forText: randomString)
    expect(mockState) == .loadingFinished
    expect(viewModel.hasData) == true
    expect(createdCellViewModels) == true
  }
  
  func testSearchFail() {
    let viewModel = AnimeListViewModel(dependencies: failingDependency)
    viewModel.mode = .searching
    
    var mockState: ViewModelNetworkRequestingState = .initial
    viewModel.state
      .subscribe(onNext: { state in
        expect(state) == mockState
        if mockState == .initial {
          mockState = .loadingStarted
        } else {
          mockState = .loadingFinished
        }
      }, onError: { error in
        expect(error.localizedDescription) == Constants.dependencyStubError.localizedDescription
      })
      .disposed(by: disposeBag)
    
    viewModel.search(forText: randomString)
    expect(mockState) == .loadingFinished
    expect(viewModel.hasData) == false
  }
  
  func testModeChange() {
    let viewModel = AnimeListViewModel(dependencies: dependency)
    viewModel.reloadData()
    expect(viewModel.cellViewModels.value.count) == Constants.animeListArrayCount
    viewModel.mode = .searching
    expect(viewModel.cellViewModels.value.count) == 0
    viewModel.mode = .default
    expect(viewModel.cellViewModels.value.count) == Constants.animeListArrayCount
    viewModel.mode = .searching
    viewModel.search(forText: randomString)
    expect(viewModel.cellViewModels.value.count) == Constants.animeListArrayCount
  }
  
  func testLoadNextPage() {
    let viewModel = AnimeListViewModel(dependencies: dependency)
    
    var loadedData = false
    var loadedNextPage = false
    viewModel.cellViewModels
      .skip(1)
      .subscribe(onNext: { cellViewModels in
        if !loadedData {
          loadedData = true
          expect(cellViewModels.count) == Constants.animeListArrayCount
          self.compareViewModels(cellViewModels, toAnimeArray: Constants.responseAnime)
        } else {
          loadedNextPage = true
          expect(cellViewModels.count) == 2 * Constants.animeListArrayCount
        }
      }, onError: { error in
        expect(error).to(beNil())
      })
      .disposed(by: disposeBag)
    
    viewModel.reloadData()
    viewModel.loadNextPage()
    expect(viewModel.hasData) == true
    expect(loadedData) == true
    expect(loadedNextPage) == true
  }
  
  func testCanLoadMorePages() {
    let viewModel = AnimeListViewModel(dependencies: dependency)
    viewModel.paginationLimit = Constants.animeListArrayCount
    
    var canLoadMorePagesChanged = false
    viewModel.canLoadMorePagesSubject
      .skip(1)
      .subscribe(onNext: { canLoadMorePages in
        expect(canLoadMorePages) == true
        canLoadMorePagesChanged = true
      })
      .disposed(by: disposeBag)
    
    viewModel.reloadData()
    expect(viewModel.hasData) == true
    expect(canLoadMorePagesChanged) == true
  }
  
  func testCannotLoadMorePages() {
    let viewModel = AnimeListViewModel(dependencies: dependency)
    viewModel.paginationLimit = Constants.animeListArrayCount * 2
    
    var canLoadMorePagesChanged = false
    viewModel.canLoadMorePagesSubject
      .skip(1)
      .subscribe(onNext: { canLoadMorePages in
        expect(canLoadMorePages) == false
        canLoadMorePagesChanged = true
      })
      .disposed(by: disposeBag)
    
    viewModel.reloadData()
    expect(viewModel.hasData) == true
    expect(canLoadMorePagesChanged) == true
  }
  
  // MARK: - Helper functions
  
  private func compareViewModels(_ viewModels: [AnimeCellViewModel], toAnimeArray animeArray: [Anime]) {
    expect(viewModels.count) == animeArray.count
    for (index, viewModel) in viewModels.enumerated() {
      let anime = animeArray[index]
      expect(viewModel.smallPosterURL) == URL(string: anime.posterImageSmall!)
      expect(viewModel.animeTitle) == anime.canonicalTitle ?? anime.englishTitle
      expect(viewModel.animeSynopsis) == anime.synopsis
    }
  }
}
