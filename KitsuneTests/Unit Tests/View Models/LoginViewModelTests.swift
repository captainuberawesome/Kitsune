//
//  LoginViewModelTests.swift
//  KitsuneTests
//
//  Created by Daria Novodon on 13/06/2018.
//

import XCTest
import Nimble
import RxNimble
import RxSwift

@testable import Kitsune

class LoginViewModelTests: XCTestCase {
  let dependency = DependencyStub()
  let failingDependency = DependencyFailureStub()
  let disposeBag = DisposeBag()
  
  func testLoadCachedData() {
    let viewModel = LoginViewModel(dependencies: dependency)
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
    waitUntil { done in
      viewModel.onDidFinishLogin
        .subscribe(onNext: {
          done()
        })
        .disposed(by: self.disposeBag)
      viewModel.login(email: "email", password: "password")
      expect(mockState) == .loadingFinished
    }
  }
  
  func testLoginError() {
    let viewModel = LoginViewModel(dependencies: failingDependency)
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
    viewModel.login(email: "email", password: "password")
    expect(mockState) == .loadingFinished
  }
}
