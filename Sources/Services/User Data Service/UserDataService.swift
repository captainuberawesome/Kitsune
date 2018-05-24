//
//  UserDataService.swift
//  Kitsune
//
//  Created by Daria Novodon on 23/05/2018.
//

import Foundation

private extension Constants {
  static let defaultServiceIdentifier = "com.dnovodon.kitsune"
}

class UserDataService {
  
  struct UserDefaultsKeys {
    static let activeUserId = "activeUserId"
  }
  
  private let userDefaults: UserDefaults
  private let serviceIdentifier: String
  
  required init(serviceIdentifier: String = Constants.defaultServiceIdentifier,
                userDefaults: UserDefaults = UserDefaults.standard) {
    self.serviceIdentifier = serviceIdentifier
    self.userDefaults = userDefaults
  }
  
  /// MARK: - Stored Data

  var activeUserId: String? {
    get {
      return userDefaults.object(forKey: serviceIdentifier + UserDefaultsKeys.activeUserId) as? String
    } set {
      userDefaults.set(newValue, forKey: serviceIdentifier + UserDefaultsKeys.activeUserId)
    }
  }
  
  // MARK: - Clear Data
  
  func clearData() {
    userDefaults.removeObject(forKey: serviceIdentifier + UserDefaultsKeys.activeUserId)
  }
  
}
