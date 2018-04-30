//
//  Date+Marshal.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import Foundation
import Marshal

extension Date: ValueType {
  public static func value(from object: Any) throws -> Date {
    guard let dateString = object as? String else {
      throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
    }
    guard let date = Constants.parsingDateFormatter.date(from: dateString) else {
      throw MarshalError.typeMismatch(expected: "yyyy-MM-dd date string", actual: dateString)
    }
    return date
  }
}
