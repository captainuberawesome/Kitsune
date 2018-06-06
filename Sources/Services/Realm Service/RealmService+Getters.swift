//
//  RealmService+Getters.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation
import RealmSwift

extension RealmService {
  
  // MARK: - Get user by id
  
  func user(withId id: String) -> User? {
    let user = realm.object(ofType: RealmUser.self, forPrimaryKey: id)
    return user?.transient()
  }
  
  // MARK: - Get anime by id
  
  func anime(withId id: String) -> Anime? {
    let anime = realm.object(ofType: RealmAnime.self, forPrimaryKey: id)
    return anime?.transient()
  }
  
}
