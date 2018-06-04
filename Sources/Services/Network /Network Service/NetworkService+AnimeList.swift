//
//  NetworkService+AnimeList.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import Alamofire
import RxSwift

extension NetworkService: AnimeListNetworkProtocol {
  
  struct AnimeListRequestKeys {
    static let textSearch = "filter[text]"
  }
  
  func animeList(limit: Int, offset: Int) -> Observable<AnimeListResponse> {
    let parameters = [PaginationKeys.limit: limit,
                      PaginationKeys.offset: offset]
    return baseRequest(method: .get, url: URLFactory.Media.anime, parameters: parameters, encoding: URLEncoding.default)
  }
  
  func animeListSearch(text: String, limit: Int, offset: Int) -> Observable<AnimeListResponse> {
    let parameters: [String: Any] = [PaginationKeys.limit: limit,
                                     PaginationKeys.offset: offset,
                                     AnimeListRequestKeys.textSearch: text]
    return baseRequest(method: .get, url: URLFactory.Media.anime, parameters: parameters, encoding: URLEncoding.default)
  }
  
}
