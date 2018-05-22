//
//  NetworkService+MyLibrary.swift
//  Kitsune
//
//  Created by Daria Novodon on 22/05/2018.
//

import Alamofire

enum LibraryEntriesKind: String {
  case anime, all = "anime,manga"
}

extension NetworkService: LibraryEntriesNetworkProtocol {
  
  struct LibraryEntriesRequestKeys {
    static let kind = "filter[kind]"
  }
  
  func libraryEntries(forUserWithId userId: Int, withLimit limit: Int, offset: Int,
                      completion: @escaping (Response<EmptyResponse>) -> Void) {
    let parameters: [String: Any] = [PaginationKeys.limit: limit,
                                     PaginationKeys.offset: offset,
                                     LibraryEntriesRequestKeys.kind: LibraryEntriesKind.anime]
    baseRequest(method: .get, url: URLFactory.UserLibraies.libraryEntries(forUserWithId: userId),
                parameters: parameters, encoding: URLEncoding.default, completion: completion)
  }
  
}
