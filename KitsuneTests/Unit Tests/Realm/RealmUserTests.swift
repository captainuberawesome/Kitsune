//
//  RealmUserTests.swift
//  Kitsune
//
//  Created by Daria Novodon on 06/06/2018.
//

import XCTest
import Nimble
@testable import Kitsune

class RealmUserTests: XCTestCase {

  // MARK: Properties
  
  private static let inMemoryIdentifier = randomString
  private var realm = RealmService(storeType: .inMemory, inMemoryIdentifier: inMemoryIdentifier)
  
  override func tearDown() {
    realm.clear()
  }
  
  // MARK: Tests

  func testRealmUser() {
    let user = createUser(id: randomString)
    
    waitUntil(timeout: 1.0) { done in
      self.realm.save(object: user) {
        
        let dbUser = self.realm.object(ofType: RealmUser.self, forPrimaryKey: user.id)?.transient()
        
        expect(dbUser).notTo(beNil())
        expect(dbUser?.id) == user.id
        expect(dbUser?.name) == user.name
        expect(dbUser?.slug) == user.slug
        expect(dbUser?.about) == user.about
        expect(dbUser?.bio) == user.bio
        expect(dbUser?.gender) == user.gender
        expect(dbUser?.location) == user.location
        expect(dbUser?.birthday) == user.birthday
        expect(dbUser?.joinDate) == user.joinDate
        expect(dbUser?.followersCount) == user.followersCount
        expect(dbUser?.followingCount) == user.followingCount
        expect(dbUser?.lifeSpentOnAnime) == user.lifeSpentOnAnime
        expect(dbUser?.website) == user.website
        expect(dbUser?.avatarThumb) == user.avatarThumb
        expect(dbUser?.avatar) == user.avatar
        expect(dbUser?.coverImage) == user.coverImage
        
        done()
      }
    }
  }
}
