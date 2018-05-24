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
    if let date = Constants.parsingDateFormatterShort.date(from: dateString) {
      return date
    }
    guard let date = Constants.parsingDateFormatterLong.date(from: dateString) else {
      throw MarshalError.typeMismatch(expected: "yyyy-MM-dd or yyyy-MM-dd'T'HH:mm:ss.SSS'Z' date string", actual: dateString)
    }
    return date
  }
}
