//
//  RealmUser.swift
//  Kitsune
//
//  Created by Daria Novodon on 23/05/2018.
//

import RealmSwift

final class RealmUser: Object, RealmEntity {
  
  typealias TransientType = User
  private static let userPrimaryKey = "id"
  
  // MARK: - Realm Properties
  
  @objc dynamic var id: String = ""
  @objc dynamic var name: String = ""
  @objc dynamic var slug: String = ""
  @objc dynamic var about: String = ""
  @objc dynamic var bio: String = ""
  @objc dynamic var location: String = ""
  @objc dynamic var followersCount: Int = 0
  @objc dynamic var followingCount: Int = 0
  @objc dynamic var lifeSpentOnAnime: Int = 0
  @objc dynamic var website: String = ""
  @objc dynamic var avatarThumb: String = ""
  @objc dynamic var avatar: String = ""
  @objc dynamic var coverImage: String = ""
  
  // MARK: - Methods
  
  override class func primaryKey() -> String? {
    return userPrimaryKey
  }
  
  // MARK: - Realm Entity
  
  static func from(transient: User, in realm: Realm) -> RealmUser {
    let cached = realm.object(ofType: RealmUser.self, forPrimaryKey: transient.id)
    let user: RealmUser
    
    if let cached = cached {
      user = cached
    } else {
      user = RealmUser()
      user.id = transient.id
    }
    user.name = transient.name
    user.slug = transient.slug
    user.about = transient.about
    user.bio = transient.bio
    user.location = transient.location
    user.followersCount = transient.followersCount
    user.followingCount = transient.followingCount
    user.lifeSpentOnAnime = transient.lifeSpentOnAnime
    user.website = transient.website
    user.avatarThumb = transient.avatarThumb
    user.avatar = transient.avatar
    user.coverImage = transient.coverImage
    return user
  }
  
  // MARK: - Transient Entity
  
  func transient() -> User {
    let transient = User()
    transient.id = id
    transient.name = name
    transient.slug = slug
    transient.about = about
    transient.bio = bio
    transient.location = location
    transient.followersCount = followersCount
    transient.followingCount = followingCount
    transient.lifeSpentOnAnime = lifeSpentOnAnime
    transient.website = website
    transient.avatarThumb = avatarThumb
    transient.avatar = avatar
    transient.coverImage = coverImage
    return transient
  }
}
