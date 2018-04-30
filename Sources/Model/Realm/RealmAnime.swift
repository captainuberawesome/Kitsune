//
//  RealmAnime.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import RealmSwift

final class RealmAnime: Object, RealmEntity {
  
  typealias TransientType = Anime
  private static let animePrimaryKey = "id"
  
  // MARK: - Realm Properties
  
  @objc dynamic var id: String = ""
  @objc dynamic var synopsis: String?
  @objc dynamic var englishTitle: String?
  @objc dynamic var japaneseTitle: String?
  @objc dynamic var canonicalTitle: String?
  @objc dynamic var averageRating: String?
  @objc dynamic var startDate: Date?
  @objc dynamic var endDate: Date?
  @objc dynamic var popularityRank: Int = 0
  @objc dynamic var ratingRank: Int = 0
  @objc dynamic var subtype: String?
  @objc dynamic var status: String?
  @objc dynamic var posterImageSmall: String?
  @objc dynamic var posterImageLarge: String?
  @objc dynamic var episodesCount: Int = 0
  @objc dynamic var episodeLength: Double = 0
  @objc dynamic var youtubeVideoId: String?
  @objc dynamic var dateSaved: Date?

  // MARK: - Methods
  
  override class func primaryKey() -> String? {
    return animePrimaryKey
  }
  
  // MARK: - Realm Entity
  
  static func from(transient: Anime, in realm: Realm) -> RealmAnime {
    let cached = realm.object(ofType: RealmAnime.self, forPrimaryKey: transient.id)
    let anime: RealmAnime
    
    if let cached = cached {
      anime = cached
    } else {
      anime = RealmAnime()
      anime.id = transient.id
    }
    anime.synopsis = transient.synopsis
    anime.englishTitle = transient.englishTitle
    anime.japaneseTitle = transient.japaneseTitle
    anime.canonicalTitle = transient.canonicalTitle
    anime.averageRating = transient.averageRating
    anime.startDate = transient.startDate
    anime.endDate = transient.endDate
    anime.popularityRank = transient.popularityRank
    anime.ratingRank = transient.ratingRank
    anime.subtype = transient.subtype?.rawValue
    anime.status = transient.status?.rawValue
    anime.posterImageSmall = transient.posterImageSmall
    anime.posterImageLarge = transient.posterImageLarge
    anime.episodesCount = transient.episodesCount
    anime.episodeLength = transient.episodeLength
    anime.youtubeVideoId = transient.youtubeVideoId
    anime.dateSaved = transient.dateSaved
    return anime
  }
  
  // MARK: - Transient Entity
  
  func transient() -> Anime {
    let transient = Anime()
    transient.id = id
    transient.synopsis = synopsis
    transient.englishTitle = englishTitle
    transient.japaneseTitle = japaneseTitle
    transient.canonicalTitle = canonicalTitle
    transient.averageRating = averageRating
    transient.startDate = startDate
    transient.endDate = endDate
    transient.popularityRank = popularityRank
    transient.ratingRank = ratingRank
    transient.subtype = AnimeSubtype(rawValue: (subtype ?? ""))
    transient.status = AnimeStatus(rawValue: (status ?? ""))
    transient.posterImageSmall = posterImageSmall
    transient.posterImageLarge = posterImageLarge
    transient.episodesCount = episodesCount
    transient.episodeLength = episodeLength
    transient.youtubeVideoId = youtubeVideoId
    transient.dateSaved = dateSaved
    return transient
  }
}
