//
//  Anime.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import Marshal

enum AnimeSubtype: String {
  case ona, ova, tv, movie, music, special
}

enum AnimeStatus: String {
  case current, finished, tba, unreleased, upcoming
}

final class Anime: NSObject, TransientEntity {
  typealias RealmType = RealmAnime
  
  // MARK: Mappable Properties
  
  var id: String = ""
  var synopsis: String?
  var englishTitle: String?
  var japaneseTitle: String?
  var canonicalTitle: String?
  var averageRating: String?
  var startDate: Date?
  var endDate: Date?
  var popularityRank: Int = 0
  var ratingRank: Int = 0
  var subtype: AnimeSubtype?
  var status: AnimeStatus?
  var posterImageSmall: String?
  var posterImageLarge: String?
  var episodesCount: Int = 0
  var episodeLength: Double = 0
  var youtubeVideoId: String?
  
  // MARK: Other Properties
  
  var dateSaved: Date?
  
  // MARK: Init
  
  override init() {
    super.init()
  }
  
  init(object: MarshaledObject) throws {
    super.init()
    try unmarshal(object: object)
  }
}

extension Anime: Unmarshaling {
  private struct Keys {
    static let id = "id"
    static let synopsis = "attributes.synopsis"
    static let englishTitle = "attributes.titles.en"
    static let japaneseTitle = "attributes.titles.ja_jp"
    static let canonicalTitle = "attributes.canonicalTitle"
    static let averageRating = "attributes.averageRating"
    static let startDate = "attributes.startDate"
    static let endDate = "attributes.endDate"
    static let popularityRank = "attributes.popularityRank"
    static let ratingRank = "attributes.ratingRank"
    static let subtype = "attributes.subtype"
    static let status = "attributes.status"
    static let posterImageSmall = "attributes.posterImage.small"
    static let posterImageLarge = "attributes.posterImage.large"
    static let episodesCount = "attributes.episodesCount"
    static let episodeLength = "attributes.episodeLength"
    static let youtubeVideoId = "attributes.youtubeVideoId"
  }
  
  func unmarshal(object: MarshaledObject) throws {
    try id = object.value(for: Keys.id)
    try? synopsis = object.value(for: Keys.synopsis)
    try? englishTitle = object.value(for: Keys.englishTitle)
    try? japaneseTitle = object.value(for: Keys.japaneseTitle)
    try? canonicalTitle = object.value(for: Keys.canonicalTitle)
    try? averageRating = object.value(for: Keys.averageRating)
    try? startDate = object.value(for: Keys.startDate)
    try? endDate = object.value(for: Keys.endDate)
    try? popularityRank = object.value(for: Keys.popularityRank)
    try? ratingRank = object.value(for: Keys.ratingRank)
    try? subtype = object.value(for: Keys.subtype)
    try? status = object.value(for: Keys.status)
    try? posterImageSmall = object.value(for: Keys.posterImageSmall)
    try? posterImageLarge = object.value(for: Keys.posterImageLarge)
    try? episodesCount = object.value(for: Keys.episodesCount)
    try? episodeLength = object.value(for: Keys.episodeLength)
    try? youtubeVideoId = object.value(for: Keys.youtubeVideoId)
  }
}
