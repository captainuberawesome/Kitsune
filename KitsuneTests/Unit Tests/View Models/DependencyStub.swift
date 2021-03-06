//
//  DependencyStub.swift
//  KitsuneTests
//
//  Created by Daria Novodon on 13/06/2018.
//

import Foundation
import RxSwift
import RxTest

@testable import Kitsune

extension Constants {
  static var dependencyStubError: Error {
    let message = R.string.networkErrors.unknown()
    let userInfo = [NSLocalizedDescriptionKey: message]
    return NSError(domain: NetworkErrorService.networkErrorDomain, code: 1, userInfo: userInfo) as Error
  }
  static let responseUser = createUser(id: randomString)
  static let animeListArrayCount = 20
  static let responseAnime: [Anime] = createAnimeList(count: animeListArrayCount)
  static let responseAnimeSearch: [Anime] = createAnimeList(count: animeListArrayCount)
}

struct DependencyStub: HasAuthService, HasLoginStateService, HasUserService, HasAnimeService, HasReachabilityService,
  HasSavedDataClearingService {
  var authService: AuthNetworkProtocol = AuthServiceStub()
  var loginStateService: LoginStateNetworkProtocol = LoginStateStub()
  var reachabilityService: ReachabilityProtocol? = ReachabilityServiceStub()
  var userService: UserService
  var animeService: AnimeService
  var savedDataClearingService: SavedDataClearingService
  
  init() {
    let inMemoryIdentifier = randomString
    let realmService = RealmService(storeType: .inMemory, inMemoryIdentifier: inMemoryIdentifier)
    let userDataService = UserDataService(serviceIdentifier: "mockUserDataService")
    userService = UserService(realmService: realmService, userNetworkService: MyProfileStub(), userDataService: userDataService)
    animeService = AnimeService(realmService: realmService, animeNetworkService: AnimeListStub())
    savedDataClearingService = SavedDataClearingService(userDataService: userDataService, realmService: realmService)
  }
}

struct DependencyFailureStub: HasAuthService, HasLoginStateService, HasUserService, HasAnimeService, HasReachabilityService,
  HasSavedDataClearingService {
  var authService: AuthNetworkProtocol = AuthServiceFailureStub()
  var loginStateService: LoginStateNetworkProtocol = LoginStateFailureStub()
  var reachabilityService: ReachabilityProtocol? = ReachabilityServiceStub()
  var userService: UserService
  var animeService: AnimeService
  var savedDataClearingService: SavedDataClearingService
  
  init() {
    let inMemoryIdentifier = randomString
    let realmService = RealmService(storeType: .inMemory, inMemoryIdentifier: inMemoryIdentifier)
    let userDataService = UserDataService(serviceIdentifier: "mockUserDataFailureService")
    userService = UserService(realmService: realmService, userNetworkService: MyProfileFailureStub(),
                              userDataService: userDataService)
    animeService = AnimeService(realmService: realmService, animeNetworkService: AnimeListFailureStub())
    savedDataClearingService = SavedDataClearingService(userDataService: userDataService, realmService: realmService)
  }
}

struct AuthServiceStub: AuthNetworkProtocol {
  func authorize(username: String, password: String) -> Observable<EmptyResponse> {
    return .just(EmptyResponse(object: [:]))
  }
  
  func signOut() -> Observable<EmptyResponse> {
    return .just(EmptyResponse(object: [:]))
  }
}

struct AuthServiceFailureStub: AuthNetworkProtocol {
  func authorize(username: String, password: String) -> Observable<EmptyResponse> {
    return .error(Constants.dependencyStubError)
  }
  
  func signOut() -> Observable<EmptyResponse> {
    return .error(Constants.dependencyStubError)
  }
}

struct LoginStateStub: LoginStateNetworkProtocol {
  var isLoggedIn: Bool {
    return true
  }
}

struct LoginStateFailureStub: LoginStateNetworkProtocol {
  var isLoggedIn: Bool {
    return false
  }
}

struct MyProfileStub: MyProfileNetworkProtocol {
  func myProfile() -> Observable<UserResponse> {
    var userResponse = UserResponse()
    userResponse.user = Constants.responseUser
    return .just(userResponse)
  }
}

struct MyProfileFailureStub: MyProfileNetworkProtocol {
  func myProfile() -> Observable<UserResponse> {
    return .error(Constants.dependencyStubError)
  }
}

struct AnimeListStub: AnimeListNetworkProtocol {
  func animeList(limit: Int, offset: Int) -> Observable<AnimeListResponse> {
    var animeListResponse = AnimeListResponse()
    animeListResponse.animeList = Constants.responseAnime
    return .just(animeListResponse)
  }
  
  func animeListSearch(text: String, limit: Int, offset: Int) -> Observable<AnimeListResponse> {
    var animeListResponse = AnimeListResponse()
    animeListResponse.animeList = Constants.responseAnimeSearch
    return .just(animeListResponse)
  }
}

struct AnimeListFailureStub: AnimeListNetworkProtocol {
  func animeList(limit: Int, offset: Int) -> Observable<AnimeListResponse> {
    return .error(Constants.dependencyStubError)
  }
  
  func animeListSearch(text: String, limit: Int, offset: Int) -> Observable<AnimeListResponse> {
    return .error(Constants.dependencyStubError)
  }
}

struct ReachabilityServiceStub: ReachabilityProtocol {
  let isReachable = BehaviorSubject<Bool>(value: true)
  func startListening() { }
  func stopListening() { }
}
