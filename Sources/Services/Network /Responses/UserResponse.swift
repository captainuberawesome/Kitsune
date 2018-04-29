//
//  UserResponse.swift
//  BumpBowl
//

import Foundation

private struct UserResponseRaw: Codable {
  var result: UserResponseResult?
}

private struct UserResponseResult: Codable {
  var user: String?
}

struct UserResponse: Codable {
  
  var userId: String?
  
  init(from decoder: Decoder) throws {
    let rawResponse = try UserResponseRaw(from: decoder)
    userId = rawResponse.result?.user
  }
  
}
