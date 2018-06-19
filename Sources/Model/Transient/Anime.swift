//
//  Anime.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import Marshal

struct Anime: TransientEntity {
  typealias RealmType = RealmAnime
  
  enum Subtype: String {
    case ona = "ONA", ova = "OVA", tv = "TV", movie, music, special
    
    var localizedDescription: String? {
      switch self {
      case .ona:
        return R.string.animeDetails.ona()
      case .ova:
        return R.string.animeDetails.ova()
      case .tv:
        return R.string.animeDetails.tv()
      case .movie:
        return R.string.animeDetails.movie()
      case .music:
        return R.string.animeDetails.music()
      case .special:
        return R.string.animeDetails.special()
      }
    }
  }
  
  enum Status: String {
    case current, finished, tba, unreleased, upcoming
    
    var localizedDescription: String? {
      switch self {
      case .current:
        return R.string.animeDetails.current()
      case .finished:
        return R.string.animeDetails.finished()
      case .tba:
        return R.string.animeDetails.tba()
      case .unreleased:
        return R.string.animeDetails.unreleased()
      case .upcoming:
        return R.string.animeDetails.upcoming()
      }
    }
  }
  
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
  var subtype: Subtype?
  var status: Status?
  var posterImageSmall: String?
  var posterImageLarge: String?
  var episodeCount: Int = 0
  var episodeLength: Double = 0
  var youtubeVideoId: String?
  
  // MARK: Other Properties
  
  var dateSaved: Date?
  
  // MARK: Init
  
  init(object: MarshaledObject) throws {
    try unmarshal(object: object)
  }
  
  init() {
    
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
    static let episodeCount = "attributes.episodeCount"
    static let episodeLength = "attributes.episodeLength"
    static let youtubeVideoId = "attributes.youtubeVideoId"
  }
  
  mutating func unmarshal(object: MarshaledObject) throws {
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
    try? episodeCount = object.value(for: Keys.episodeCount)
    try? episodeLength = object.value(for: Keys.episodeLength)
    try? youtubeVideoId = object.value(for: Keys.youtubeVideoId)
  }
}
