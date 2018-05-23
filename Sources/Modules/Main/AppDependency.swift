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

protocol HasRealmService {
  var realmService: RealmService { get }
}

protocol HasUserDataService {
  var userDataService: UserDataService { get }
}

protocol HasAuthService {
  var authService: AuthNetworkProtocol { get }
}

protocol HasLoginStateService {
  var loginStateService: LoginStateNetworkProtocol { get }
}

protocol HasAnimeListService {
  var animeListService: AnimeListNetworkProtocol { get }
}

protocol HasMyProfileService {
  var myProfileService: MyProfileNetworkProtocol { get }
}

class AppDependency: HasRealmService, HasReachabilityManager, HasUserDataService {
  let userDataService: UserDataService
  let realmService: RealmService
  let networkManager: NetworkService
  private(set) var reachabilityManager: ReachabilityManager?
  
  init(userDataService: UserDataService,
       realmService: RealmService,
       networkManager: NetworkService,
       reachabilityManager: ReachabilityManager?) {
    self.userDataService = userDataService
    self.realmService = realmService
    self.networkManager = networkManager
    self.reachabilityManager = reachabilityManager
  }
  
  static func makeDefault() -> AppDependency {
    let userDataService = UserDataService()
    let realmService = RealmService()
    let networkManager = NetworkService()
    let reachabilityManager = ReachabilityManager(host: URLFactory.ReachabilityChecking.host)
    return AppDependency(userDataService: userDataService,
                         realmService: realmService,
                         networkManager: networkManager,
                         reachabilityManager: reachabilityManager)
  }
}

extension AppDependency: HasAuthService, HasAnimeListService,
  HasLoginStateService, HasMyProfileService {
  var authService: AuthNetworkProtocol { return networkManager }
  var animeListService: AnimeListNetworkProtocol { return networkManager }
  var loginStateService: LoginStateNetworkProtocol { return networkManager }
  var myProfileService: MyProfileNetworkProtocol { return networkManager }
}
