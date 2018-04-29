//
//  Common.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation

struct WeakWrapper<T: AnyObject> {
  weak var value: T?
  init (value: T) {
    self.value = value
  }
}
