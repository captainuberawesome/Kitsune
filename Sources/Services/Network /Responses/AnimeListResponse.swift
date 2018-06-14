//
//  AnimeListResponse.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import Marshal

struct AnimeListResponse: Unmarshaling {
  private struct Keys {
    static let data = "data"
  }
  
  var animeList: [Anime] = []
  
  init() {
  }
  
  init(object: MarshaledObject) throws {
    try? animeList = object.value(for: Keys.data)
  }
}
