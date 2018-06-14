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
    
  let dependency = DependencyMock()
  let failingDependency = DependencyFailureMock()
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
        // TODO: compare view model parameters to expected values
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
        expect(error.localizedDescription) == Constants.dependencyMockError.localizedDescription
      })
      .disposed(by: disposeBag)
    
    viewModel.reloadData()
    expect(mockState) == .loadingFinished
    expect(viewModel.hasData) == false
  }
  
  // TODO: test search request success / failure, test loadNextPage(), test mode change and canLoadMorePagesSubject 
}
