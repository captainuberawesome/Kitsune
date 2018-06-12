//
//  ErrorResponse.swift
//  BumpBowl
//

import Marshal

private struct ServerError: Unmarshaling {
  private struct Keys {
    static let message = "title"
    static let code = "code"
  }
  
  var message: String?
  var code: String?
  
  init(object: MarshaledObject) throws {
    try? message = object.value(for: Keys.message)
    try code = object.value(for: Keys.code)
  }
}

struct ErrorResponse: Unmarshaling {
  private struct Keys {
    static let errors = "errors"
  }
  
  private var errors: [ServerError] = []
  var message: String?
  var code: Int = 0
  
  init(object: MarshaledObject) throws {
    try? errors = object.value(for: Keys.errors)
    message = errors.first?.message
    if let codeString = errors.first?.code, let code = Int(codeString) {
      self.code = code
    } else {
      throw MarshalError.typeMismatch(expected: "code is integer", actual: (errors.first?.code ?? "nil"))
    }
  }
}
