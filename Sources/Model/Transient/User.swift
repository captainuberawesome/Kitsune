//
//  User.swift
//  Kitsune
//
//  Created by Daria Novodon on 23/05/2018.
//

import Marshal

final class User: NSObject, TransientEntity {
  typealias RealmType = RealmUser
  
  // MARK: Mappable Properties
  
  var id: String = ""
  var name: String = ""
  var slug: String = ""
  var about: String = ""
  var bio: String = ""
  var location: String = ""
  var followersCount: Int = 0
  var followingCount: Int = 0
  var lifeSpentOnAnime: Int = 0
  var website: String = ""
  var avatarThumb: String = ""
  var avatar: String = ""
  
  // MARK: Init
  
  override init() {
    super.init()
  }
  
  init(object: MarshaledObject) throws {
    super.init()
    try unmarshal(object: object)
  }
}

extension User: Unmarshaling {
  private struct Keys {
    static let id = "id"
    static let name = "attributes.name"
    static let slug = "attributes.slug"
    static let about = "attributes.about"
    static let bio = "attributes.bio"
    static let location = "attributes.location"
    static let followersCount = "attributes.followersCount"
    static let followingCount = "attributes.followingCount"
    static let lifeSpentOnAnime = "attributes.lifeSpentOnAnime"
    static let website = "attributes.website"
    static let avatarThumb = "attributes.avatar.small"
    static let avatar = "attributes.avatar.large"
  }
  
  func unmarshal(object: MarshaledObject) throws {
    try id = object.value(for: Keys.id)
    try? name = object.value(for: Keys.name)
    try? slug = object.value(for: Keys.slug)
    try? about = object.value(for: Keys.about)
    try? bio = object.value(for: Keys.bio)
    try? location = object.value(for: Keys.location)
    try? followersCount = object.value(for: Keys.followersCount)
    try? followingCount = object.value(for: Keys.followingCount)
    try? lifeSpentOnAnime = object.value(for: Keys.lifeSpentOnAnime)
    try? website = object.value(for: Keys.website)
    try? avatarThumb = object.value(for: Keys.avatarThumb)
    try? avatar = object.value(for: Keys.avatar)
  }
}
