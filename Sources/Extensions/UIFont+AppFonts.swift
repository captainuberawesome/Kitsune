//
//  UIFont+AppFonts.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import UIKit

extension UIFont {
  static func josefinSans(ofSize size: CGFloat) -> UIFont {
    return font(withName: R.font.josefinSans.fontName, ofSize: size)
  }
  
  static func josefinSansBold(ofSize size: CGFloat) -> UIFont {
    return font(withName: R.font.josefinSansBold.fontName, ofSize: size)
  }
  
  static func josefinSansSemiBold(ofSize size: CGFloat) -> UIFont {
    return font(withName: R.font.josefinSansSemiBold.fontName, ofSize: size)
  }
  
  static func josefinSansLight(ofSize size: CGFloat) -> UIFont {
    return font(withName: R.font.josefinSansLight.fontName, ofSize: size)
  }
  
  private static func font(withName name: String, ofSize size: CGFloat) -> UIFont {
    guard let font = UIFont(name: name, size: size) else {
      fatalError("Can't find \(name) font")
    }
    return font
  }
}
