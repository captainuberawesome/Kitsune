//
//  ErrorResponse.swift
//  BumpBowl
//

import Foundation

private struct ErrorResponseRaw: Codable {
  var error: ErrorResponseError?
  var code: Int = 0
}

private struct ErrorResponseError: Codable {
  var error: String?
}

struct ErrorResponse: Codable {
  
  var message: String?
  var code: Int = 0
  
  init(from decoder: Decoder) throws {
    let rawResponse = try ErrorResponseRaw(from: decoder)
    message = rawResponse.error?.error
    code = rawResponse.code
  }
  
}
