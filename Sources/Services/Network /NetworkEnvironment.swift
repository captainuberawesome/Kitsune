//
//  NetworkEnvironment.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation

private extension Constants {
  static let defaultURL = ""
  static let defaultreachabilityHost = "www.apple.com"
}

class NetworkEnvironment {
  let baseRestURLString: String
  let reachabilityHost: String
  
  class var current: NetworkEnvironment {
    return NetworkEnvironment()
  }

  private init() {
    baseRestURLString = Constants.defaultURL
    reachabilityHost = Constants.defaultreachabilityHost
  }
}
