//
//  UIViewController+Children.swift
//  Kitsune
//
//  Created by Daria Novodon on 20/05/2018.
//

import UIKit

extension UIViewController {
  func addChildViewController(_ viewController: UIViewController, toView view: UIView) {
    guard viewController.view.superview == nil else { return }
    addChildViewController(viewController)
    view.addSubview(viewController.view)
    viewController.view.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    viewController.didMove(toParentViewController: self)
  }
  
  func removeChildController(_ viewController: UIViewController) {
    guard viewController.view.superview != nil else { return }
    viewController.willMove(toParentViewController: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParentViewController()
  }
}
