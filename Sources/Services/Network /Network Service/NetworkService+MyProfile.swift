//
//  NetworkService+MyProfile.swift
//  Kitsune
//
//  Created by Daria Novodon on 23/05/2018.
//

import Alamofire
import RxSwift

extension NetworkService: MyProfileNetworkProtocol {
  
  struct MyProfileRequestKeys {
    static let myProfile = "filter[self]"
  }
  
  func myProfile() -> Observable<UserResponse> {
    let parameters: [String: Any] = [MyProfileRequestKeys.myProfile: true.stringValue]
    return baseRequest(method: .get, url: URLFactory.Users.users, parameters: parameters, encoding: URLEncoding.default)
  }
  
}
