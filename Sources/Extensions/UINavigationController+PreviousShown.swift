//
//  UINavigationController+PreviousShown.swift
//  Kitsune
//
//  Created by Daria Novodon on 19/06/2018.
//

import UIKit

extension UINavigationController {
  var poppedViewController: UIViewController? {
    guard let fromViewController = transitionCoordinator?.viewController(forKey: .from),
      !viewControllers.contains(fromViewController) else {
        return nil
    }
    return fromViewController
  }
}
