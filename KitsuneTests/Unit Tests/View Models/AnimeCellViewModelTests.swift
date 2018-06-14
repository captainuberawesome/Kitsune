//
//  AnimeCellViewModelTests.swift
//  KitsuneTests
//
//  Created by Daria Novodon on 14/06/2018.
//

import XCTest
import Nimble

@testable import Kitsune

class AnimeCellViewModelTests: XCTestCase {
        
  func testAnimeCellViewModel() {
    let cellReuseIdentifier = randomString
    let anime = createAnime(id: randomString)
    let animeCellViewModel = AnimeCellViewModel(anime: anime, cellReuseIdentifier: cellReuseIdentifier)
    expect(animeCellViewModel.cellReuseIdentifier) == cellReuseIdentifier
    expect(animeCellViewModel.smallPosterURL) == URL(string: anime.posterImageSmall!)
    expect(animeCellViewModel.animeTitle) == anime.canonicalTitle ?? anime.englishTitle
    expect(animeCellViewModel.animeSynopsis) == anime.synopsis
  }
    
}