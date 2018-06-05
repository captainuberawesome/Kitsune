//
//  LoginViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import Foundation
import RxSwift

protocol LoginViewModelDelegate: class {
  func loginViewModelDidFinishLogin(_ viewModel: LoginViewModel)
}

class LoginViewModel: ViewModelNetworkRequesting {
  
  typealias Dependencies = HasAuthService
  
  private let dependencies: Dependencies
  private let disposeBag = DisposeBag()
  let state = BehaviorSubject<ViewModelNetworkRequestingState>(value: .initial)
  
  weak var delegate: LoginViewModelDelegate?
  
  var onErrorEncountered: ((_ error: Error?) -> Void)?
  
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
        DispatchQueue.main.async {
          self.delegate?.loginViewModelDidFinishLogin(self)
        }
      }, onError: { error in
        self.state.onError(error)
      })
      .disposed(by: disposeBag)
  }
}
