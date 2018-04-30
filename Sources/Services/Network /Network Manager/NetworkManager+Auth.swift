//
//  NetworkManager+Auth.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Alamofire.Swift

extension NetworkManager: AuthNetworkProtocol {
  
  func authorize(username: String, password: String, completion: @escaping (Response<EmptyResponse>) -> Void) {
    baseAuthorizationRequest(username: username, password: password, completion: completion)
  }
  
}
