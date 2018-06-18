//
//  AnimeCellViewModelTests.swift
//  KitsuneTests
//
//  Created by Daria Novodon on 14/06/2018.
//

import XCTest
import Nimble
import RxNimble
import RxSwift

@testable import Kitsune

class AnimeCellViewModelTests: XCTestCase {
  
  let disposeBag = DisposeBag()
  
  func testAnimeCellViewModel() {
    let anime = createAnime(id: randomString)
    let animeCellViewModel = AnimeCellViewModel(anime: anime)
    expect(animeCellViewModel.smallPosterURL) == URL(string: anime.posterImageSmall!)
    expect(animeCellViewModel.animeTitle) == anime.canonicalTitle ?? anime.englishTitle
    expect(animeCellViewModel.animeSynopsis) == anime.synopsis
    
    var wasSelected = false
    animeCellViewModel.onSelected
      .subscribe(onNext: { selectedAnime in
        expect(selectedAnime.id) == anime.id
        wasSelected = true
      })
      .disposed(by: disposeBag)
    animeCellViewModel.select()
    expect(wasSelected) == true
  }
}
