//
//  AnimeDetailsViewModelTests.swift
//  KitsuneTests
//
//  Created by Daria Novodon on 18/06/2018.
//

import XCTest
import Nimble

@testable import Kitsune

class AnimeDetailsViewModelTests: XCTestCase {
  
  func testAnimeDetailsViewModel() {
    let anime = createAnime(id: randomString)
    let viewModel = AnimeDetailsViewModel(anime: anime)
    expect(viewModel.englishTitle) == anime.englishTitle ?? anime.canonicalTitle
    expect(viewModel.japaneseTitle) == anime.japaneseTitle
    expect(viewModel.type) == anime.subtype?.localizedDescription
    expect(viewModel.episodeCount) == "\(anime.episodeCount)"
    expect(viewModel.status) == anime.status?.localizedDescription
    expect(viewModel.posterImageURL) == URL(string: anime.posterImageLarge!)
    expect(viewModel.synopsis) == anime.synopsis
    expect(viewModel.airDates) == "Mar 11, 2001 to Jun 9, 2006"
  }
}
