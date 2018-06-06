//
//  UserUnmarshalingTests.swift
//  Kitsune
//
//  Created by Daria Novodon on 06/06/2018.
//

import XCTest
import Nimble
import Marshal
@testable import Kitsune

class UserUnmarshalingTests: XCTestCase {
  
  // MARK: - Aux Methods
  
  func createUser(from json: JSONObject, file: FileString = #file, line: UInt = #line) -> User? {
    do {
      return try User(object: json as MarshaledObject)
    } catch let error {
      fail(error.localizedDescription, file: file, line: line)
      return nil
    }
  }
  
  // MARK: - Tests
  
  //swiftlint:disable:next function_body_length
  func testUser() {
    let id = randomString
    let name = randomString
    let slug = randomString
    let about = randomString
    let bio = randomString
    let gender = randomString
    let location = randomString
    let birthday = randomDate ?? Date()
    let joinDate = randomDate ?? Date()
    let followersCount = randomInt
    let followingCount = randomInt
    let lifeSpentOnAnime = randomInt
    let website = randomString
    let avatarThumb = randomString
    let avatar = randomString
    let coverImage = randomString
    
    let json: JSONObject = [
      "id": id,
      "attributes": [
        "name": name,
        "slug": slug,
        "about": about,
        "bio": bio,
        "gender": gender,
        "location": location,
        "birthday": Constants.parsingDateFormatterShort.string(from: birthday),
        "createdAt": Constants.parsingDateFormatterLong.string(from: joinDate),
        "followersCount": followersCount,
        "followingCount": followingCount,
        "lifeSpentOnAnime": lifeSpentOnAnime,
        "website": website,
        "avatar": [
          "small": avatarThumb,
          "large": avatar
        ],
        "coverImage": [
          "original": coverImage
        ]
      ]
    ]
    
    let user = createUser(from: json)
    
    expect(user).notTo(beNil())
    expect(user?.id) == id
    expect(user?.name) == name
    expect(user?.slug) == slug
    expect(user?.about) == about
    expect(user?.bio) == bio
    expect(user?.gender) == gender
    expect(user?.location) == location
    expect(user?.birthday).to(beCloseTo(birthday, within: 60 * 60 * 24))
    expect(user?.joinDate).to(beCloseTo(joinDate, within: 0.001))
    expect(user?.followersCount) == followersCount
    expect(user?.followingCount) == followingCount
    expect(user?.lifeSpentOnAnime) == lifeSpentOnAnime
    expect(user?.website) == website
    expect(user?.avatarThumb) == avatarThumb
    expect(user?.avatar) == avatar
    expect(user?.coverImage) == coverImage
  }
}
