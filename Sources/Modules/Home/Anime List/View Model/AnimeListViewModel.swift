//
//  AnimeListViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import Foundation

class AnimeListViewModel {
  typealias Dependencies = HasAnimeListService
  
  private let dependencies: Dependencies
  private(set) var cellViewModels: [AnimeCellViewModel] = []
  
  var onErrorEncountered: ((NSError?) -> Void)?
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  func reloadData() {
    dependencies.animeListService.animeList { response in
      
    }
  }
}
