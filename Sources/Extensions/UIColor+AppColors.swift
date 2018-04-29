//
//  UIColor+AppColors.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit

extension UIColor {
  
  // MARK: - Common
  
  class func color(fromRed red: Int, green: Int, blue: Int, alpha: CGFloat = 1) -> UIColor {
    return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: alpha)
  }
  
}
