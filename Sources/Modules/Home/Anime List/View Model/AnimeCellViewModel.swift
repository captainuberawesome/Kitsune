//
//  AnimeCellViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import Foundation
import RxSwift
import RxCocoa

class AnimeCellViewModel {
  private let anime: Anime
  private(set) var onSelected = PublishSubject<Anime>()
  
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
  
  init(anime: Anime) {
    self.anime = anime
  }
  
  // MARK: - Public functions
  
  func select() {
    onSelected.onNext(anime)
  }
}
