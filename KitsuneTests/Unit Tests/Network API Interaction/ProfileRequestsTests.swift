//
//  ProfileRequestsTests.swift
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
  static let profile = [
    "data": [
      [ "id": "161" ]
    ]
  ]
  static let error = [
    "errors": [
      [
        "title": "error_title",
        "detail": "error_detail",
        "code": "123",
        "status": "",
        "source": [
          "pointer": "",
          "parameter": ""
        ]
      ]
    ]
  ]
}

class ProfileRequestsTests: BaseNetworkTestCase {
  
  // MARK: - Test Profile
  
  func testGetProfile() {
    let profileURL = "\(URLFactory.Users.users)?filter%5Bself%5D=true"
    let stub = MockingjayProtocol.addStub(matcher: uri(profileURL),
                                          builder: json(ResponseJSON.profile, status: 200, headers: nil))
    
    var networkRequest: Request?
    let observable = networkService.myProfile(onRequestCreated: { request in
      networkRequest = request
      self.expectRequest(request,
                         toHaveMethod: .get,
                         url: profileURL)
    })
    let result = try? observable
      .toBlocking()
      .first()
    expect(result??.user?.id) == "161"
    expect(networkRequest).toNot(beNil())
    MockingjayProtocol.removeStub(stub)
  }
  
  func testProfileError() {
    let profileURL = "\(URLFactory.Users.users)?filter%5Bself%5D=true"
    let stub = MockingjayProtocol.addStub(matcher: uri(profileURL),
                                          builder: json(ResponseJSON.error, status: 404, headers: nil))
    
    let observable = networkService.myProfile()
    let result = observable
      .toBlocking()
      .materialize()
    switch result {
    case .completed:
      expect(false) == true
    case .failed(_, let error):
      expect(error.localizedDescription) == "error_title"
      expect((error as NSError).code) == 123
    }
    MockingjayProtocol.removeStub(stub)
  }
}
