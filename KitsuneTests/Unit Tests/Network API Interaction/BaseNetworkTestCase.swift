//
//  BaseNetworkTestCase.swift
//  Kitsune
//
//  Created by Daria Novodon on 12/06/2018.
//

import XCTest
import Mockingjay
import Alamofire
import Nimble

@testable import Kitsune

class BaseNetworkTestCase: XCTestCase {
  var networkService: NetworkService!
  
  override func setUp() {
    super.setUp()
    networkService = NetworkService(useKeychain: false)
  }
  
  override func tearDown() {
    MockingjayProtocol.removeAllStubs()
    super.tearDown()
  }
}
