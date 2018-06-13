//
//  DependencyMock.swift
//  KitsuneTests
//
//  Created by Daria Novodon on 13/06/2018.
//

import Foundation
import RxSwift
import RxTest

@testable import Kitsune

extension Constants {
  static var dependencyMockError: Error {
    let message = R.string.networkErrors.unknown()
    let userInfo = [NSLocalizedDescriptionKey: message]
    return NSError(domain: NetworkErrorService.networkErrorDomain, code: 1, userInfo: userInfo) as Error
  }
  static let responseUser = createUser(id: randomString)
}

struct DependencyMock: HasAuthService, HasLoginStateService, HasMyProfileService, HasUserDataService, HasRealmService {
  private static let inMemoryIdentifier = randomString
  var authService: AuthNetworkProtocol = AuthServiceMock()
  var loginStateService: LoginStateNetworkProtocol = LoginStateMock()
  var myProfileService: MyProfileNetworkProtocol = MyProfileMock()
  var userDataService: UserDataService = UserDataService(serviceIdentifier: "mockUserDataService")
  var realmService: RealmService = RealmService(storeType: .inMemory, inMemoryIdentifier: inMemoryIdentifier)
  
}

struct DependencyFailureMock: HasAuthService, HasLoginStateService, HasMyProfileService, HasUserDataService, HasRealmService {
  private static let inMemoryIdentifier = randomString
  var authService: AuthNetworkProtocol = AuthServiceFailureMock()
  var loginStateService: LoginStateNetworkProtocol = LoginStateFailureMock()
  var myProfileService: MyProfileNetworkProtocol = MyProfileFailureMock()
  var userDataService: UserDataService = UserDataService(serviceIdentifier: "mockUserDataFailureService")
  var realmService: RealmService = RealmService(storeType: .inMemory, inMemoryIdentifier: inMemoryIdentifier)
}

struct AuthServiceMock: AuthNetworkProtocol {
  func authorize(username: String, password: String) -> Observable<EmptyResponse> {
    return .just(EmptyResponse(object: [:]))
  }
  
  func signOut() -> Observable<EmptyResponse> {
    return .just(EmptyResponse(object: [:]))
  }
}

struct AuthServiceFailureMock: AuthNetworkProtocol {
  func authorize(username: String, password: String) -> Observable<EmptyResponse> {
    return .error(Constants.dependencyMockError)
  }
  
  func signOut() -> Observable<EmptyResponse> {
    return .error(Constants.dependencyMockError)
  }
}

struct LoginStateMock: LoginStateNetworkProtocol {
  var isLoggedIn: Bool {
    return true
  }
}

struct LoginStateFailureMock: LoginStateNetworkProtocol {
  var isLoggedIn: Bool {
    return false
  }
}

struct MyProfileMock: MyProfileNetworkProtocol {
  func myProfile() -> Observable<UserResponse> {
    var userResponse = UserResponse()
    userResponse.user = Constants.responseUser
    return .just(userResponse)
  }
}

struct MyProfileFailureMock: MyProfileNetworkProtocol {
  func myProfile() -> Observable<UserResponse> {
    return .error(Constants.dependencyMockError)
  }
}
