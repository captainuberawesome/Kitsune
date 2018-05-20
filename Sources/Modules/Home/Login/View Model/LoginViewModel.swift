//
//  LoginViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import Foundation

protocol LoginViewModelDelegate: class {
  func loginViewModelDidFinishLogin(_ viewModel: LoginViewModel)
}

class LoginViewModel {
  
  typealias Dependencies = HasAuthService
  
  private let dependencies: Dependencies
  
  weak var delegate: LoginViewModelDelegate?
  
  var onErrorEncountered: ((_ error: Error?) -> Void)?
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Public
  
  func login(email: String, password: String) {
    dependencies.authService.authorize(username: email, password: password) { response in
      switch response {
      case .success:
        self.delegate?.loginViewModelDidFinishLogin(self)
      case .failure(let error):
        self.onErrorEncountered?(error)
      }
    }
  }
}
