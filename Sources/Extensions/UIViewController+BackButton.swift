//
//  UIViewController+BackButton.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/06/2018.
//

import UIKit

extension UIViewController {
  func setDefaultBackButtonTitle() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
}
