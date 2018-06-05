//
//  MainCoordinatorUtility.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation
import RxSwift

class MainCoordinatorUtility {
  typealias Dependencies = HasReachabilityService & HasRealmService & HasAuthService
    & HasUserDataService
  
  private struct Constants {
    static let hadFirstRunAlreadyUserDefaultsKey = "hadFirstRunAlready"
  }
  
  private let disposeBag = DisposeBag()
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
    dependencies.reachabilityService?.startListening()
  }
  
  private func resetDataOnFirstRun() {
    let notFirstRun = userDefaults.bool(forKey: Constants.hadFirstRunAlreadyUserDefaultsKey)
    if !notFirstRun {
      userDefaults.set(true, forKey: Constants.hadFirstRunAlreadyUserDefaultsKey)
      clearUserData()
    }
  }
  
  func clearUserData(completion: (() -> Void)? = nil) {
    dependencies.userDataService.clearData()
    dependencies.realmService.clear(completion: completion)
  }
  
  func signOut(completion: (() -> Void)? = nil) {
    dependencies.authService.signOut()
      .subscribe(onNext: { _ in
        self.clearUserData(completion: completion)
      }, onError: { _ in
        self.clearUserData(completion: completion)
      })
      .disposed(by: disposeBag)
  }
}
