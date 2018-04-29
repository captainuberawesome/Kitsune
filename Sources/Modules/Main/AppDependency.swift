//
//  AppDependency.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation

protocol HasReachabilityManager {
  var reachabilityManager: ReachabilityManager? { get }
}

protocol HasUserDataStore {
  var userDataStore: UserDataStore { get }
}

protocol HasRealmWrapper {
  var realmWrapper: RealmWrapper { get }
}

protocol HasAuthService {
  var authService: AuthNetworkProtocol { get }
}

class AppDependency: HasUserDataStore, HasRealmWrapper, HasReachabilityManager {
  let userDataStore: UserDataStore
  let realmWrapper: RealmWrapper
  let networkManager: NetworkManager
  private(set) var reachabilityManager: ReachabilityManager?
  
  init(userDataStore: UserDataStore,
       realmWrapper: RealmWrapper,
       networkManager: NetworkManager,
       reachabilityManager: ReachabilityManager?) {
    self.userDataStore = userDataStore
    self.realmWrapper = realmWrapper
    self.networkManager = networkManager
    self.reachabilityManager = reachabilityManager
  }
  
  static func makeDefault() -> AppDependency {
    let userDataStore = UserDataStore()
    let realmWrapper = RealmWrapper()
    let networkManager = NetworkManager()
    let reachabilityManager = ReachabilityManager(host: URLFactory.ReachabilityChecking.host)
    return AppDependency(userDataStore: userDataStore,
                         realmWrapper: realmWrapper,
                         networkManager: networkManager,
                         reachabilityManager: reachabilityManager)
  }
}

extension AppDependency: HasAuthService {
  var authService: AuthNetworkProtocol { return networkManager }
}
