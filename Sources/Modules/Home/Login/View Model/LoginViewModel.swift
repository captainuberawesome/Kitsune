//
//  LoginViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import Foundation
import RxSwift

class LoginViewModel: ViewModelNetworkRequesting {
  
  typealias Dependencies = HasAuthService
  
  private let dependencies: Dependencies
  private let disposeBag = DisposeBag()
  let state = BehaviorSubject<ViewModelNetworkRequestingState>(value: .initial)
  var onDidFinishLogin = PublishSubject<Void>()
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Public
  
  func login(email: String, password: String) {
    state.onNext(.loadingStarted)
    dependencies.authService.authorize(username: email, password: password)
      .subscribe(onNext: { _ in
        self.state.onNext(.loadingFinished)
        self.onDidFinishLogin.onNext(())
      }, onError: { error in
        self.state.onError(error)
      })
      .disposed(by: disposeBag)
  }
}
