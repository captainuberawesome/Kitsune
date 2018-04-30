//
//  NetworkService+Auth.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Alamofire

extension NetworkService: AuthNetworkProtocol {
  
  func authorize(username: String, password: String, completion: @escaping (Response<EmptyResponse>) -> Void) {
    baseAuthorizationRequest(username: username, password: password, completion: completion)
  }
  
  func signOut(completion: @escaping (Response<EmptyResponse>) -> Void) {
    baseSignOutRequest(completion: completion)
  }
  
}
