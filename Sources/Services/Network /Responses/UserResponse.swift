//
//  UserResponse.swift
//  Kitsune
//
//  Created by Daria Novodon on 23/05/2018.
//

import Marshal

struct UserResponse: Unmarshaling {
  private struct Keys {
    static let data = "data"
  }
  
  var user: User?
  private var users: [User]
  
  init(object: MarshaledObject) throws {
    try users = object.value(for: Keys.data)
    user = users.first
  }
}
