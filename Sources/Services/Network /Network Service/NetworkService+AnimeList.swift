//
//  NetworkService+AnimeList.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import Alamofire

extension NetworkService: AnimeListNetworkProtocol {
  
  struct AnimeListRequestKeys {
    static let textSearch = "filter[text]"
  }
  
  func animeList(limit: Int, offset: Int, completion: @escaping (Response<AnimeListResponse>) -> Void) {
    let parameters = [PaginationKeys.limit: limit,
                      PaginationKeys.offset: offset]
    baseRequest(method: .get, url: URLFactory.Media.anime, parameters: parameters,
                encoding: URLEncoding.default, completion: completion)
  }
  
  func animeListSearch(text: String, limit: Int, offset: Int, completion: @escaping (Response<AnimeListResponse>) -> Void) {
    let parameters: [String: Any] = [PaginationKeys.limit: limit,
                                     PaginationKeys.offset: offset,
                                     AnimeListRequestKeys.textSearch: text]
    baseRequest(method: .get, url: URLFactory.Media.anime, parameters: parameters,
                encoding: URLEncoding.default, completion: completion)
  }
  
}
