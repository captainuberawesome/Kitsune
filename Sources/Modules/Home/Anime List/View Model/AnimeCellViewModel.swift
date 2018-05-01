//
//  AnimeCellViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import Foundation

class AnimeCellViewModel {
  let cellReuseIdentifier: String
  private let anime: Anime
  
  // MARK: - Public computed propeties
  
  var smallPosterURL: URL? {
    guard let smallPosterURLString = anime.posterImageSmall else { return nil }
    return URL(string: smallPosterURLString)
  }
  
  var animeTitle: String? {
    return anime.canonicalTitle ?? anime.englishTitle
  }
  
  var animeSynopsis: String? {
    return anime.synopsis
  }
  
  // MARK: - Init
  
  init(anime: Anime, cellReuseIdentifier: String) {
    self.anime = anime
    self.cellReuseIdentifier = cellReuseIdentifier
  }
}
