//
//  TestDataGeneration.swift
//  Kitsune
//
//  Created by Daria Novodon on 06/06/2018.
//

import Foundation
@testable import Kitsune

// MARK: - Properties

var randomBool: Bool {
  return Int(arc4random_uniform(100)) % 2 == 0
}

var randomDouble: Double {
  return Double(arc4random_uniform(1000)) / Double(arc4random_uniform(1000))
}

var randomDate: Date? {
  let daysBack = randomInt
  let day = arc4random_uniform(UInt32(daysBack))+1
  let hour = arc4random_uniform(23)
  let minute = arc4random_uniform(59)
  
  let today = Date(timeIntervalSinceNow: 0)
  let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
  var offsetComponents = DateComponents()
  offsetComponents.day = -Int(day - 1)
  offsetComponents.hour = Int(hour)
  offsetComponents.minute = Int(minute)
  
  let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
  return randomDate
}

var randomString: String {
  return UUID().uuidString
}

var randomInt: Int {
  return Int(arc4random_uniform(1000))
}

var randomImageURLString: String {
  return "https://images.com/images/\(randomString).jpg"
}

var randomAnimeSubtype: AnimeSubtype {
  let availableValues: [AnimeSubtype] = [.ona, .ova, .tv, .movie, .music, .special]
  let index = Int(arc4random_uniform(UInt32(availableValues.count - 1)))
  return availableValues[index]
}

var randomAnimeStatus: AnimeStatus {
  let availableValues: [AnimeStatus] = [.current, .finished, .tba, .unreleased, .upcoming]
  let index = Int(arc4random_uniform(UInt32(availableValues.count - 1)))
  return availableValues[index]
}

var randomInfoType: ProfileCellViewModel.InfoType {
  let availableValues: [ProfileCellViewModel.InfoType] = [.gender, .location, .birthday, .joinDate]
  let index = Int(arc4random_uniform(UInt32(availableValues.count - 1)))
  return availableValues[index]
}

var dateFormatter: DateFormatter = {
  let dateFormatter = DateFormatter()
  dateFormatter.locale = Constants.appLocale
  dateFormatter.dateFormat = "MMMM dd yyyy"
  return dateFormatter
}()

func createUser(id: String) -> User {
  let user = User()
  user.id = id
  user.name = randomString
  user.slug = randomString
  user.about = randomString
  user.bio = randomString
  user.gender = randomString
  user.location = randomString
  user.birthday = dateFormatter.date(from: "January 21 1900")
  user.joinDate = dateFormatter.date(from: "April 29 2018")
  user.followersCount = randomInt
  user.followingCount = randomInt
  user.lifeSpentOnAnime = randomInt
  user.website = randomImageURLString
  user.avatarThumb = randomImageURLString
  user.avatar = randomImageURLString
  user.coverImage = randomImageURLString
  return user
}

func createAnime(id: String) -> Anime {
  let anime = Anime()
  anime.id = id
  anime.synopsis = randomString
  anime.englishTitle = randomString
  anime.japaneseTitle = randomString
  anime.canonicalTitle = randomString
  anime.averageRating = randomString
  anime.startDate = dateFormatter.date(from: "March 11 2001")
  anime.endDate = dateFormatter.date(from: "June 09 2006")
  anime.popularityRank = randomInt
  anime.ratingRank = randomInt
  anime.subtype = randomAnimeSubtype
  anime.status = randomAnimeStatus
  anime.posterImageSmall = randomImageURLString
  anime.posterImageLarge = randomImageURLString
  anime.episodeCount = randomInt
  anime.episodeLength = randomDouble
  anime.youtubeVideoId = randomImageURLString
  return anime
}

func createAnimeList(count: Int) -> [Anime] {
  var animeList: [Anime] = []
  for _ in 0..<count {
    let anime = createAnime(id: randomString)
    animeList.append(anime)
  }
  return animeList
}
