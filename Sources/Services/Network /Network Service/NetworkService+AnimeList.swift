//
//  NetworkService+AnimeList.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import Alamofire

extension NetworkService: AnimeListNetworkProtocol {
  
  func animeList(completion: @escaping (Response<EmptyResponse>) -> Void) {
    baseRequest(method: .get, url: URLFactory.Anime.list, completion: completion)
  }
  
}
