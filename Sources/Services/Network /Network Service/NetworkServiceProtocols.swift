//
//  NetworkServiceProtocols.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Alamofire.Swift
import Marshal

// MARK: - Types

enum Response<T: Unmarshaling> {
  case success(T)
  case failure(Error?)
}

// MARK: - Protocols

// MARK: Auth

protocol AuthNetworkProtocol {
  func authorize(username: String, password: String, completion: @escaping (Response<EmptyResponse>) -> Void)
  func signOut(completion: @escaping (Response<EmptyResponse>) -> Void)
}

protocol LoginStateNetworkProtocol {
  var isLoggedIn: Bool { get }
}

protocol AnimeListNetworkProtocol {
   func animeList(limit: Int, offset: Int, completion: @escaping (Response<AnimeListResponse>) -> Void)
}
