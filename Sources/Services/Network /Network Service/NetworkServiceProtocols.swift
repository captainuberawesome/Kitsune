//
//  NetworkServiceProtocols.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Alamofire.Swift
import Marshal
import RxSwift

// MARK: - Protocols

// MARK: Auth

protocol AuthNetworkProtocol {
  func authorize(username: String, password: String) -> Observable<EmptyResponse>
  func signOut() -> Observable<EmptyResponse>
}

protocol LoginStateNetworkProtocol {
  var isLoggedIn: Bool { get }
}

protocol AnimeListNetworkProtocol {
  func animeList(limit: Int, offset: Int) -> Observable<AnimeListResponse>
  func animeListSearch(text: String, limit: Int, offset: Int) -> Observable<AnimeListResponse>
}

protocol MyProfileNetworkProtocol {
  func myProfile() -> Observable<UserResponse>
}
