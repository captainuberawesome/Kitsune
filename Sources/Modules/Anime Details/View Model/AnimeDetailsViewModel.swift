//
//  AnimeDetailsViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/06/2018.
//

import Foundation

class AnimeDetailsViewModel {
  private let anime: Anime
  lazy private var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Constants.appLocale
    dateFormatter.dateFormat = "MMM d, yyyy"
    return dateFormatter
  }()
  
  // MARK: - Init
  
  init(anime: Anime) {
    self.anime = anime
  }
  
  // MARK: - Computed properties
  
  var englishTitle: String? {
    return anime.englishTitle ?? anime.canonicalTitle
  }
  
  var japaneseTitle: String? {
    return anime.japaneseTitle
  }
  
  var type: String? {
    return anime.subtype?.localizedDescription
  }
  
  var episodeCount: String? {
    return "\(anime.episodeCount)"
  }
  
  var status: String? {
    return anime.status?.localizedDescription
  }
  
  var airDates: String? {
    guard let startDate = anime.startDate, let endDate = anime.endDate else { return nil }
    let beginning = dateFormatter.string(from: startDate)
    let end = dateFormatter.string(from: endDate)
    let conjunction = R.string.animeDetails.datesConjunction()
    if beginning == end {
      return "\(beginning)"
    }
    return "\(beginning) \(conjunction) \(end)"
  }
  
  var posterImageURL: URL? {
    guard let posterImageURLString = anime.posterImageLarge else { return nil }
    return URL(string: posterImageURLString)
  }

  var synopsis: String? {
    return anime.synopsis
  }
}
