//
//  UIViewController+ErrorHandling.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit

extension UIViewController {

  func handle(error: NSError?, tapBlock: (() -> Void)? = nil) {
    guard let error = error else {
      return
    }
    let message = error.localizedDescription
    let title = R.string.common.error()
    self.showAlert(withTitle: title, message: message, tapBlock: tapBlock)
  }
  
}
