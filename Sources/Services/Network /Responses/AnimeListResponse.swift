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
    static let count = "meta.count"
    static let nextLink = "links.next"
  }
  
  var animeList: [Anime] = []
  var count: Int = 0
  var nextLink: String?
  
  init(object: MarshaledObject) throws {
    try? animeList = object.value(for: Keys.data)
    try? count = object.value(for: Keys.count)
    try? nextLink = object.value(for: Keys.nextLink)
  }
}
