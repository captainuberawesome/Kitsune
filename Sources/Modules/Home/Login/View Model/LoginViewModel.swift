//
//  LoginViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import Foundation

class LoginViewModel {
  typealias Dependencies = HasAuthService
  
  private let dependencies: Dependencies
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
}
