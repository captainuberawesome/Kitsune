//
//  Date+DaySuffix.swift
//  Kitsune
//
//  Created by Daria Novodon on 24/05/2018.
//

import Foundation

extension Date {
  var daySuffix: String {
    let dayOfMonth = Calendar.current.component(.day, from: self)
    switch dayOfMonth {
    case 1, 21, 31: return "st"
    case 2, 22: return "nd"
    case 3, 23: return "rd"
    default: return "th"
    }
  }
}
