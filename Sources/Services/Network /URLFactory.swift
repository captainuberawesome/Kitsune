//
//  URLFactory.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation

struct URLFactory {
  private static let environment = NetworkEnvironment.current
  private static let baseRestURLString = environment.baseRestURLString
  
  struct ReachabilityChecking {
    static let host = environment.reachabilityHost
  }

  struct Auth {
    static let oauth = environment.authorizeURL
    static let accessToken = oauth + "/token"
  }
  
  struct Media {
    static let anime = baseRestURLString + "/anime"
  }
  
  struct Users {
    static let users = baseRestURLString + "/users"
  }
  
}
