//
//  AuthViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation

class AuthViewModel {
  typealias Dependencies = HasAuthService
  
  private let dependencies: Dependencies
  
  var onErrorEncountered: ((NSError?) -> Void)?
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Public
  
  func login(username: String?, password: String?) {
    guard let username = username, let password = password else { return }
    dependencies.authService.authorize(username: username, password: password) { response in
      switch response {
      case .success:
        break
      case .failure(let error):
        self.onErrorEncountered?(error)
      }
    }
  }
  
}
