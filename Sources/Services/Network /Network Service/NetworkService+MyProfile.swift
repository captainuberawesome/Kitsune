//
//  NetworkService+MyProfile.swift
//  Kitsune
//
//  Created by Daria Novodon on 23/05/2018.
//

import Alamofire

extension NetworkService: MyProfileNetworkProtocol {
  
  struct MyProfileRequestKeys {
    static let myProfile = "filter[self]"
  }
  
  func myProfile(completion: @escaping (Response<UserResponse>) -> Void) {
    let parameters: [String: Any] = [MyProfileRequestKeys.myProfile: true.stringValue]
    baseRequest(method: .get, url: URLFactory.Users.users,
                parameters: parameters, encoding: URLEncoding.default, completion: completion)
  }
  
}
