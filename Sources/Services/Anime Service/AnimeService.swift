//
//  AnimeService.swift
//  Kitsune
//
//  Created by Daria Novodon on 19/06/2018.
//

import Foundation
import RxSwift

struct AnimeService {
  
  private let animeNetworkService: AnimeListNetworkProtocol
  private let animeRealmSevice: AnimeRealmService
  
  init(realmService: RealmService, animeNetworkService: AnimeListNetworkProtocol) {
    self.animeNetworkService = animeNetworkService
    animeRealmSevice = AnimeRealmService(realmService: realmService)
  }
  
  func savedAnime(withId id: String) -> Anime? {
   return animeRealmSevice.anime(withId: id)
  }
  
  func animeList(limit: Int, offset: Int) -> Observable<AnimeListResponse> {
    return animeNetworkService.animeList(limit: limit, offset: offset)
  }
  
  func animeListSearch(text: String, limit: Int, offset: Int) -> Observable<AnimeListResponse> {
    return animeNetworkService.animeListSearch(text: text, limit: limit, offset: offset)
  }
  
}
