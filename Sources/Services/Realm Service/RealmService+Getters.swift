//
//  RealmService+Getters.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation
import RealmSwift

extension RealmService {
  
  // MARK: - Get User by id
  
  func user(withId id: String) -> User? {
    let user = persistentRealm.object(ofType: RealmUser.self, forPrimaryKey: id)
    return user?.transient()
  }
  
}
