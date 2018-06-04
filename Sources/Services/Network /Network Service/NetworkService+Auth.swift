//
//  NetworkService+Auth.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Alamofire
import RxSwift

extension NetworkService: AuthNetworkProtocol {
  
  func authorize(username: String, password: String) -> Observable<EmptyResponse> {
    return baseAuthorizationRequest(username: username, password: password)
  }
  
  func signOut() -> Observable<EmptyResponse> {
    return baseSignOutRequest()
  }
  
}
