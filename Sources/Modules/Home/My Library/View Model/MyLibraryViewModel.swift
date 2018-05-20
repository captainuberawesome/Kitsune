//
//  MyLibraryViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import Foundation

class MyLibraryViewModel {
  typealias Dependencies = HasLoginStateService
  
  private let dependencies: Dependencies
  
  var isLoggedIn: Bool {
    return dependencies.loginStateService.isLoggedIn
  }
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
}
