//
//  AnimeRealmService.swift
//  Kitsune
//
//  Created by Daria Novodon on 19/06/2018.
//

import Foundation

struct AnimeRealmService {
  
  private let realmService: RealmService
  
  init(realmService: RealmService) {
    self.realmService = realmService
  }
  
  func anime(withId id: String) -> Anime? {
    let anime = realmService.object(ofType: RealmAnime.self, forPrimaryKey: id)
    return anime?.transient()
  }
  
}
