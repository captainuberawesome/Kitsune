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

protocol HasAuthService {
  var authService: AuthNetworkProtocol { get }
}

protocol HasLoginStateService {
  var loginStateService: LoginStateNetworkProtocol { get }
}

protocol HasAnimeService {
  var animeService: AnimeService { get }
}

protocol HasUserService {
  var userService: UserService { get }
}

protocol HasSavedDataClearingService {
  var savedDataClearingService: SavedDataClearingService { get }
}

struct AppDependency: HasReachabilityService, HasAnimeService, HasUserService, HasSavedDataClearingService {
  private let networkService: NetworkService
  let savedDataClearingService: SavedDataClearingService
  let animeService: AnimeService
  let userService: UserService
  private(set) var reachabilityService: ReachabilityProtocol?
  
  static let `default`: AppDependency = {
    let userDataService = UserDataService()
    let realmService = RealmService()
    let networkService = NetworkService()
    let reachabilityService = ReachabilityService(host: URLFactory.ReachabilityChecking.host)
    let userService = UserService(realmService: realmService, userNetworkService: networkService,
                                  userDataService: userDataService)
    let animeService = AnimeService(realmService: realmService, animeNetworkService: networkService)
    let savedDataClearingService = SavedDataClearingService(userDataService: userDataService,
                                                            realmService: realmService)
    return AppDependency(networkService: networkService, savedDataClearingService: savedDataClearingService,
                         animeService: animeService, userService: userService, reachabilityService: reachabilityService)
  }()
}

extension AppDependency: HasAuthService, HasLoginStateService {
  var authService: AuthNetworkProtocol { return networkService }
  var loginStateService: LoginStateNetworkProtocol { return networkService }
}
