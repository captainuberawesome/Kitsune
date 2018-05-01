//
//  UIFont+AppFonts.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import UIKit

extension UIFont {
  static func appFont(ofSize size: CGFloat) -> UIFont {
    return font(withName: R.font.robotoCondensedRegular.fontName, ofSize: size)
  }
  
  static func boldAppFont(ofSize size: CGFloat) -> UIFont {
    return font(withName: R.font.robotoCondensedBold.fontName, ofSize: size)
  }
  
  private static func font(withName name: String, ofSize size: CGFloat) -> UIFont {
    guard let font = UIFont(name: name, size: size) else {
      fatalError("Can't find \(name) font")
    }
    return font
  }
}
