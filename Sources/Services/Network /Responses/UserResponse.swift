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
  
  var user: User
  
  init(object: MarshaledObject) throws {
    try user = object.value(for: Keys.data)
  }
}
