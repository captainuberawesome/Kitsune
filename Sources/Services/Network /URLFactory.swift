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
    static let auth = baseRestURLString + "functions/newUser"
  }
}
