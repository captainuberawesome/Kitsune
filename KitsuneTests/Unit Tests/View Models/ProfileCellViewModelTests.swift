//
//  ProfileCellViewModelTests.swift
//  KitsuneTests
//
//  Created by Daria Novodon on 13/06/2018.
//

import XCTest
import Nimble

@testable import Kitsune

class ProfileCellViewModelTests: XCTestCase {
    
  func testProfileCellViewModel() {
    let cellReuseIdentifier = randomString
    let infoType = randomInfoType
    let value = randomString
    let profileCellViewModel = ProfileCellViewModel(infoType: infoType, value: value, cellReuseIdentifier: cellReuseIdentifier)
    expect(profileCellViewModel.cellReuseIdentifier) == cellReuseIdentifier
    expect(profileCellViewModel.infoType) == infoType
    expect(profileCellViewModel.value) == value
  }
  
}
