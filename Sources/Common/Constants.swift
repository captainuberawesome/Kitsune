//
//  Constants.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation

struct Constants {
  static var appName: String? {
    return Bundle.main.infoDictionary!["CFBundleName"] as? String
  }
  
  static let realmInMemoryStoreIdentifier = "inMemoryRealm"
  static let appLocale = Locale(identifier: "en_US")

  static var parsingDateFormatterShort: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
  }()
  
  static var parsingDateFormatterLong: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return dateFormatter
  }()
}
