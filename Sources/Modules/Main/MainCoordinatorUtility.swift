//
//  MainCoordinatorUtility.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation

class MainCoordinatorUtility {
  typealias Dependencies = HasReachabilityManager & HasRealmService & HasAuthService
  
  private struct Constants {
    static let hadFirstRunAlreadyUserDefaultsKey = "hadFirstRunAlready"
  }
  
  private let dependencies: Dependencies
  private let userDefaults: UserDefaults
  
  var pushReceivedOnLaunch: [AnyHashable: Any]?
  
  init(dependencies: Dependencies,
       userDefaults: UserDefaults = .standard) {
    self.dependencies = dependencies
    self.userDefaults = userDefaults
  }
  
  func start() {
    startListeningForReachabilityUpdates()
    resetDataOnFirstRun()
  }
  
  private func startListeningForReachabilityUpdates() {
    dependencies.reachabilityManager?.startListening()
  }
  
  private func resetDataOnFirstRun() {
    let notFirstRun = userDefaults.bool(forKey: Constants.hadFirstRunAlreadyUserDefaultsKey)
    if !notFirstRun {
      userDefaults.set(true, forKey: Constants.hadFirstRunAlreadyUserDefaultsKey)
      clearUserData()
    }
  }
  
  func clearUserData(completion: (() -> Void)? = nil) {
    dependencies.realmService.clear(completion: completion)
  }
  
  func signOut(completion: (() -> Void)? = nil) {
    dependencies.authService.signOut { _ in
      self.clearUserData(completion: completion)
    }
  }
}
