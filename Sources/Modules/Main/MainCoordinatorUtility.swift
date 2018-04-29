//
//  MainCoordinatorUtility.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation

class MainCoordinatorUtility {
  typealias Dependencies = HasUserDataStore & HasReachabilityManager & HasRealmWrapper & HasAuthService
  
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
  
  var isLoggedIn: Bool {
    return dependencies.userDataStore.token != nil
  }
  
  func start() {
    startListeningForReachabilityUpdates()
    resetDataOnFirstRun()
  }
  
  func updateDataBase(completion: VoidBlock? = nil) {
    dependencies.realmWrapper.overwriteInMemoryDataWithPersistent {
      completion?()
    }
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
    dependencies.userDataStore.clearData()
    dependencies.realmWrapper.clearAll(completion: completion)
  }
  
  func signOut(completion: @escaping ((Error?) -> Void)) {
    
  }
}
