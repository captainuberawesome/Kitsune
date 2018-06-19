//
//  UserServie.swift
//  Kitsune
//
//  Created by Daria Novodon on 19/06/2018.
//

import Foundation
import RxSwift

struct UserService {
  
  private let userNetworkService: MyProfileNetworkProtocol
  private let userRealmSevice: UserRealmService
  private let userDataService: UserDataService
  
  init(realmService: RealmService, userNetworkService: MyProfileNetworkProtocol, userDataService: UserDataService) {
    self.userNetworkService = userNetworkService
    self.userDataService = userDataService
    userRealmSevice = UserRealmService(realmService: realmService)
  }
  
  func savedUser(withId id: String) -> User? {
    return userRealmSevice.user(withId: id)
  }
  
  func savedActiveUser() -> User? {
    guard let activeUserId = userDataService.activeUserId else { return nil }
    return savedUser(withId: activeUserId)
  }
  
  func myProfile() -> Observable<UserResponse> {
    return userNetworkService.myProfile()
  }
  
  func saveActiveUserId(_ id: String) {
    userDataService.activeUserId = id
  }

  func save(user: User, completion: (() -> Void)? = nil) {
    userRealmSevice.save(user: user, completion: completion)
  }
}
