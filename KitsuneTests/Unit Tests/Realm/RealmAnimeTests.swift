//
//  RealmAnimeTests.swift
//  Kitsune
//
//  Created by Daria Novodon on 06/06/2018.
//

import XCTest
import Nimble
@testable import Kitsune

class RealmAnimeTests: XCTestCase {

  // MARK: Properties
  
  private static let inMemoryIdentifier = randomString
  private var realm = RealmService(storeType: .inMemory, inMemoryIdentifier: inMemoryIdentifier)
  
  override func tearDown() {
    realm.clear()
  }
  
  // MARK: Tests
  
  func testRealmAnime() {
    
    let anime = Anime()
    anime.id = randomString
    anime.synopsis = randomString
    anime.englishTitle = randomString
    anime.japaneseTitle = randomString
    anime.canonicalTitle = randomString
    anime.averageRating = randomString
    anime.startDate = randomDate
    anime.endDate = randomDate
    anime.popularityRank = randomInt
    anime.ratingRank = randomInt
    anime.subtype = randomAnimeSubtype
    anime.status = randomAnimeStatus
    anime.posterImageSmall = randomString
    anime.posterImageLarge = randomString
    anime.episodesCount = randomInt
    anime.episodeLength = randomDouble
    anime.youtubeVideoId = randomString
    
    waitUntil(timeout: 1.0) { done in
      self.realm.save(object: anime) {
        
        let dbAnime = self.realm.anime(withId: anime.id)
        
        expect(dbAnime).notTo(beNil())
        expect(dbAnime?.id) == anime.id
        expect(dbAnime?.synopsis) == anime.synopsis
        expect(dbAnime?.englishTitle) == anime.englishTitle
        expect(dbAnime?.japaneseTitle) == anime.japaneseTitle
        expect(dbAnime?.canonicalTitle) == anime.canonicalTitle
        expect(dbAnime?.averageRating) == anime.averageRating
        expect(dbAnime?.startDate) == anime.startDate
        expect(dbAnime?.endDate) == anime.endDate
        expect(dbAnime?.popularityRank) == anime.popularityRank
        expect(dbAnime?.ratingRank) == anime.ratingRank
        expect(dbAnime?.subtype) == anime.subtype
        expect(dbAnime?.status) == anime.status
        expect(dbAnime?.posterImageSmall) == anime.posterImageSmall
        expect(dbAnime?.posterImageLarge) == anime.posterImageLarge
        expect(dbAnime?.episodesCount) == anime.episodesCount
        expect(dbAnime?.episodeLength) == anime.episodeLength
        expect(dbAnime?.youtubeVideoId) == anime.youtubeVideoId
        
        done()
      }
    }
  }
}
