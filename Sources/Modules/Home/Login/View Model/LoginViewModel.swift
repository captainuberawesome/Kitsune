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

class LoginViewModel {
  
  typealias Dependencies = HasAuthService
  
  private let dependencies: Dependencies
  private let disposeBag = DisposeBag()
  
  weak var delegate: LoginViewModelDelegate?
  
  var onErrorEncountered: ((_ error: Error?) -> Void)?
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Public
  
  func login(email: String, password: String) {
    dependencies.authService.authorize(username: email, password: password)
      .subscribe(onNext: { _ in
        DispatchQueue.main.async {
          self.delegate?.loginViewModelDidFinishLogin(self)
        }
      }, onError: { error in
        DispatchQueue.main.async {
          self.onErrorEncountered?(error)
        }
      })
      .disposed(by: disposeBag)
  }
}
