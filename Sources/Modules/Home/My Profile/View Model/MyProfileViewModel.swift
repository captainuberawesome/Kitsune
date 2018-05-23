//
//  MyProfileViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import Foundation

private extension Constants {
  static let defaultPaginationLimit = 10
}

class MyProfileViewModel {
  
  typealias Dependencies = HasLoginStateService & HasMyProfileService
    & HasUserDataService & HasRealmService
  
  private let dependencies: Dependencies
  private var user: User?
  
  var isLoggedIn: Bool {
    return dependencies.loginStateService.isLoggedIn
  }
  
  var onErrorEncountered: ((Error?) -> Void)?
  var onLoadingStarted: (() -> Void)?
  var onLoadingFinished: (() -> Void)?
  var onUIReloadRequested: (() -> Void)?

  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Public
  
  func loadCachedData() {
    guard let activeUserId = dependencies.userDataService.activeUserId else { return }
    user = dependencies.realmService.user(withId: activeUserId)
    onUIReloadRequested?()
  }
  
  func reloadData() {
    onLoadingStarted?()
    dependencies.myProfileService.myProfile { response in
      self.onLoadingFinished?()
      switch response {
      case .success(let result):
        self.user = result.user
        self.dependencies.realmService.save(object: result.user)
        DispatchQueue.main.async {
          self.onUIReloadRequested?()
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self.onErrorEncountered?(error)
        }
      }
    }
  }
  
}
