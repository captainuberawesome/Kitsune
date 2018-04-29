//
//  UserDataStore.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation
import KeychainAccess

class UserDataStore {
  
  struct KeychainKeys {
    static let token = "token"
  }
  
  struct UserDefaultsKeys {
    static let activeUserId = "activeUserId"
  }
  
  // Can't use bundle identifier here since the keychain needs to be shared between the app and extensions
  static let defaultService = "com.dnovodon.kitsune"
  
  let keychain: Keychain
  let userDefaults: UserDefaults
  
  required init(service: String = defaultService, userDefaults: UserDefaults = UserDefaults.standard) {
    self.keychain =  Keychain(service: service)
    self.userDefaults = userDefaults
  }
  
  /// MARK: - Stored Data
  
  var token: String? {
    get {
      var token: String? = nil
      do {
        token = try keychain.getString(KeychainKeys.token)
      } catch let error {
        log.debug("Error while getting value for token, error: \(error)")
      }
      return token
    }
    set {
      guard let newValue = newValue else {
        return
      }
      do {
        try keychain.set(newValue, key: KeychainKeys.token)
      } catch let error {
        log.debug("Error while setting value: \(newValue) for token, error: \(error)")
      }
    }
  }
  
  var activeUserId: Int? {
    get {
      return userDefaults.object(forKey: keychain.service + UserDefaultsKeys.activeUserId) as? Int
    }
    set {
      userDefaults.set(newValue, forKey: keychain.service + UserDefaultsKeys.activeUserId)
    }
  }
  
  // MARK: - Clear Data
  
  func clearData() {
    userDefaults.removeObject(forKey: keychain.service + UserDefaultsKeys.activeUserId)
    do {
      try keychain.removeAll()
    } catch let error {
      log.debug("error while clearing keychain data: \(error)")
    }
  }
  
}
