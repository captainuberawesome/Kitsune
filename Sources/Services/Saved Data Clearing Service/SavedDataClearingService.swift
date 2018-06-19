//
//  SavedDataClearingService.swift
//  Kitsune
//
//  Created by Daria Novodon on 19/06/2018.
//

import Foundation

struct SavedDataClearingService {
  
  private let userDataService: UserDataService
  private let realmService: RealmService
  
  init(userDataService: UserDataService, realmService: RealmService) {
    self.userDataService = userDataService
    self.realmService = realmService
  }
  
  func clearSavedData(completion: (() -> Void)? = nil) {
    userDataService.clearData()
    realmService.clear(completion: completion)
  }
}
