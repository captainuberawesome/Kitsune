//
//  AnimeUnmarshalingTests.swift
//  Kitsune
//
//  Created by Daria Novodon on 06/06/2018.
//

import XCTest
import Nimble
import Marshal
@testable import Kitsune

class AnimeUnmarshalingTests: XCTestCase {
  
  // MARK: - Aux Methods
  
  func createAnime(from json: JSONObject, file: FileString = #file, line: UInt = #line) -> Anime? {
    do {
      return try Anime(object: json as MarshaledObject)
    } catch let error {
      fail(error.localizedDescription, file: file, line: line)
      return nil
    }
  }
  
  // MARK: - Tests
  
  //swiftlint:disable:next function_body_length
  func testAnime() {
    let id = randomString
    let synopsis = randomString
    let englishTitle = randomString
    let japaneseTitle = randomString
    let canonicalTitle = randomString
    let averageRating = randomString
    let startDate = randomDate ?? Date()
    let endDate = randomDate ?? Date()
    let popularityRank = randomInt
    let ratingRank = randomInt
    let subtype = randomAnimeSubtype
    let status = randomAnimeStatus
    let posterImageSmall = randomString
    let posterImageLarge = randomString
    let episodesCount = randomInt
    let episodeLength = randomDouble
    let youtubeVideoId = randomString
    
    let json: JSONObject = [
      "id": id,
      "attributes": [
        "synopsis": synopsis,
        "titles": [
          "en": englishTitle,
          "ja_jp": japaneseTitle
        ],
        "canonicalTitle": canonicalTitle,
        "averageRating": averageRating,
        "startDate": Constants.parsingDateFormatterLong.string(from: startDate),
        "endDate": Constants.parsingDateFormatterLong.string(from: endDate),
        "popularityRank": popularityRank,
        "ratingRank": ratingRank,
        "subtype": subtype.rawValue,
        "status": status.rawValue,
        "episodesCount": episodesCount,
        "episodeLength": episodeLength,
        "youtubeVideoId": youtubeVideoId,
        "posterImage": [
          "small": posterImageSmall,
          "large": posterImageLarge
        ]
      ]
    ]
    
    let anime = createAnime(from: json)
    
    expect(anime).notTo(beNil())
    expect(anime?.id) == id
    expect(anime?.synopsis) == synopsis
    expect(anime?.englishTitle) == englishTitle
    expect(anime?.japaneseTitle) == japaneseTitle
    expect(anime?.canonicalTitle) == canonicalTitle
    expect(anime?.averageRating) == averageRating
    expect(anime?.startDate).to(beCloseTo(startDate, within: 0.001))
    expect(anime?.endDate).to(beCloseTo(endDate, within: 0.001))
    expect(anime?.popularityRank) == popularityRank
    expect(anime?.ratingRank) == ratingRank
    expect(anime?.subtype) == subtype
    expect(anime?.status) == status
    expect(anime?.posterImageSmall) == posterImageSmall
    expect(anime?.posterImageLarge) == posterImageLarge
    expect(anime?.episodesCount) == episodesCount
    expect(anime?.episodeLength).to(beCloseTo(episodeLength))
    expect(anime?.youtubeVideoId) == youtubeVideoId
  }
    
}
