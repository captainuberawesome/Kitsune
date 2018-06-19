//
//  DateWithOrdinalSuffixTest.swift
//  KitsuneTests
//
//  Created by Daria Novodon on 19/06/2018.
//

import XCTest
import Nimble

@testable import Kitsune

class DateWithOrdinalSuffixTest: XCTestCase {
  
  func testDayWithOrdinalSuffix() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    let date1 = dateFormatter.date(from: "23.03.2018")
    expect(date1?.dayWithOrdinalSuffix) == "23rd"
    let date2 = dateFormatter.date(from: "02.05.2018")
    expect(date2?.dayWithOrdinalSuffix) == "2nd"
    let date3 = dateFormatter.date(from: "31.05.2018")
    expect(date3?.dayWithOrdinalSuffix) == "31st"
    let date4 = dateFormatter.date(from: "12.06.2018")
    expect(date4?.dayWithOrdinalSuffix) == "12th"
  }
  
}
