//
//  AppDependency.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation

protocol HasReachabilityService {
  var reachabilityService: ReachabilityProtocol? { get }
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

class AppDependency: HasRealmService, HasReachabilityService, HasUserDataService {
  let userDataService: UserDataService
  let realmService: RealmService
  let networkService: NetworkService
  private(set) var reachabilityService: ReachabilityProtocol?
  
  init(userDataService: UserDataService,
       realmService: RealmService,
       networkService: NetworkService,
       reachabilityService: ReachabilityProtocol?) {
    self.userDataService = userDataService
    self.realmService = realmService
    self.networkService = networkService
    self.reachabilityService = reachabilityService
  }
  
  static func makeDefault() -> AppDependency {
    let userDataService = UserDataService()
    let realmService = RealmService()
    let networkService = NetworkService()
    let reachabilityService = ReachabilityService(host: URLFactory.ReachabilityChecking.host)
    return AppDependency(userDataService: userDataService,
                         realmService: realmService,
                         networkService: networkService,
                         reachabilityService: reachabilityService)
  }
}

extension AppDependency: HasAuthService, HasAnimeListService,
  HasLoginStateService, HasMyProfileService {
  var authService: AuthNetworkProtocol { return networkService }
  var animeListService: AnimeListNetworkProtocol { return networkService }
  var loginStateService: LoginStateNetworkProtocol { return networkService }
  var myProfileService: MyProfileNetworkProtocol { return networkService }
}
