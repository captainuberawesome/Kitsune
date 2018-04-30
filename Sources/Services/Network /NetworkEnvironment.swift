//
//  NetworkEnvironment.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation

private extension Constants {
  static let defaultURL = "https://kitsu.io/api/edge/"
  static let defaultreachabilityHost = "www.apple.com"
  static let authorizeURL = "https://kitsu.io/api/oauth"
}

class NetworkEnvironment {
  let baseRestURLString: String
  let reachabilityHost: String
  let authorizeURL: String
  
  class var current: NetworkEnvironment {
    return NetworkEnvironment()
  }

  private init() {
    baseRestURLString = Constants.defaultURL
    reachabilityHost = Constants.defaultreachabilityHost
    authorizeURL = Constants.authorizeURL
  }
}
