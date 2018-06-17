//
//  String+RegularExpression.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/06/2018.
//

import Foundation

extension String {
  func matches(regularExpression: String) -> Bool {
    return self.range(of: regularExpression, options: .regularExpression, range: nil, locale: nil) != nil
  }
}
