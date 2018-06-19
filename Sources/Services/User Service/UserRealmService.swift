//
//  UserRealmService.swift
//  Kitsune
//
//  Created by Daria Novodon on 19/06/2018.
//

import Foundation

struct UserRealmService {
  
  private let realmService: RealmService
  
  init(realmService: RealmService) {
    self.realmService = realmService
  }
  
  func user(withId id: String) -> User? {
    let user = realmService.object(ofType: RealmUser.self, forPrimaryKey: id)
    return user?.transient()
  }
  
  func save(user: User, completion: (() -> Void)? = nil) {
    realmService.save(object: user, completion: completion)
  }
  
}
