//
//  Date+DaySuffix.swift
//  Kitsune
//
//  Created by Daria Novodon on 24/05/2018.
//

import Foundation

extension Date {
  var dayWithOrdinalSuffix: String? {
    let dayOfMonth = Calendar.current.component(.day, from: self)
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .ordinal
    return numberFormatter.string(from: dayOfMonth as NSNumber)
  }
}
