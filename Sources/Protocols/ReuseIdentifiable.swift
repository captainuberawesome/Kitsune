//
//  ReuseIdentifiable.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit

protocol ReuseIdentifiable {
  static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell: ReuseIdentifiable { }
extension UITableViewHeaderFooterView: ReuseIdentifiable { }
extension UICollectionReusableView: ReuseIdentifiable { }
