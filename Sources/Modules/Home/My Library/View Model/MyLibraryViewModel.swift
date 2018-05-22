//
//  MyLibraryViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import Foundation

private extension Constants {
  static let defaultPaginationLimit = 10
}

class MyLibraryViewModel {
  
  typealias Dependencies = HasLoginStateService
  
  private let dependencies: Dependencies
  var paginationLimit = Constants.defaultPaginationLimit
  
  var isLoggedIn: Bool {
    return dependencies.loginStateService.isLoggedIn
  }

  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
}
