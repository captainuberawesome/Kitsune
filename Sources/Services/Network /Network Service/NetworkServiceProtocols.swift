//
//  NetworkServiceProtocols.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Alamofire.Swift

// MARK: - Types

enum Response<T: Decodable> {
  case success(T)
  case failure(Error?)
}

// MARK: - Protocols

// MARK: Auth

protocol AuthNetworkProtocol {
  func authorize(username: String, password: String, completion: @escaping (Response<EmptyResponse>) -> Void)
  func signOut(completion: @escaping (Response<EmptyResponse>) -> Void)
}

protocol AnimeListNetworkProtocol {
  func animeList(completion: @escaping (Response<EmptyResponse>) -> Void)
}
