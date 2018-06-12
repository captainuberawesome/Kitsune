//
//  AnimeRequestsTests.swift
//  Kitsune
//
//  Created by Daria Novodon on 12/06/2018.
//

import XCTest
import Mockingjay
import Alamofire
import RxNimble
import Nimble

@testable import Kitsune

private struct ResponseJSON {
  static let anime = [
    "data": [
      [ "id": "1" ],
      [ "id": "2" ],
      [ "id": "3" ]
    ]
  ]
}

class AnimeRequestsTests: BaseNetworkTestCase {
  
  func testGetAnimeList() {
    let limit = randomInt
    let offset = randomInt
    let url = "\(URLFactory.Media.anime)?page%5Blimit%5D=\(limit)&page%5Boffset%5D=\(offset)"
    
    let stub = MockingjayProtocol.addStub(matcher: uri(url),
                                          builder: json(ResponseJSON.anime,
                                                        status: 200, headers: nil))
    var networkRequest: Request?
    let observable = networkService.animeList(limit: limit, offset: offset, onRequestCreated: { request in
      networkRequest = request
      self.expectRequest(request,
                         toHaveMethod: .get,
                         url: url)
    })
    let result = try? observable
      .toBlocking()
      .first()
    expect(result??.animeList.count) == 3
    expect(result??.animeList[0].id) == "1"
    expect(result??.animeList[1].id) == "2"
    expect(result??.animeList[2].id) == "3"
    expect(networkRequest).toNot(beNil())
    MockingjayProtocol.removeStub(stub)
  }
  
  func testGetAnimeSearchList() {
    let limit = randomInt
    let offset = randomInt
    let text = randomString
    let url = "\(URLFactory.Media.anime)?filter%5Btext%5D=\(text)&page%5Blimit%5D=\(limit)&page%5Boffset%5D=\(offset)"
    
    let stub = MockingjayProtocol.addStub(matcher: uri(url),
                                          builder: json(ResponseJSON.anime,
                                                        status: 200, headers: nil))
    var networkRequest: Request?
    let observable = networkService.animeListSearch(text: text, limit: limit, offset: offset, onRequestCreated: { request in
      networkRequest = request
      self.expectRequest(request,
                         toHaveMethod: .get,
                         url: url)
    })
    let result = try? observable
      .toBlocking()
      .first()
    expect(result??.animeList.count) == 3
    expect(result??.animeList[0].id) == "1"
    expect(result??.animeList[1].id) == "2"
    expect(result??.animeList[2].id) == "3"
    expect(networkRequest).toNot(beNil())
    MockingjayProtocol.removeStub(stub)
  }
  
}
