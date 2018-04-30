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

protocol HasAuthService {
  var authService: AuthNetworkProtocol { get }
}

protocol HasAnimeListService {
  var animeListService: AnimeListNetworkProtocol { get }
}

class AppDependency: HasRealmService, HasReachabilityManager {
  let realmService: RealmService
  let networkManager: NetworkService
  private(set) var reachabilityManager: ReachabilityManager?
  
  init(realmService: RealmService,
       networkManager: NetworkService,
       reachabilityManager: ReachabilityManager?) {
    self.realmService = realmService
    self.networkManager = networkManager
    self.reachabilityManager = reachabilityManager
  }
  
  static func makeDefault() -> AppDependency {
    let realmService = RealmService()
    let networkManager = NetworkService()
    let reachabilityManager = ReachabilityManager(host: URLFactory.ReachabilityChecking.host)
    return AppDependency(realmService: realmService,
                         networkManager: networkManager,
                         reachabilityManager: reachabilityManager)
  }
}

extension AppDependency: HasAuthService, HasAnimeListService {
  var authService: AuthNetworkProtocol { return networkManager }
  var animeListService: AnimeListNetworkProtocol { return networkManager }
}
