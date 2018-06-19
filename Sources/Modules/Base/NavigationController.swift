//
//  NavigationController.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit

class NavigationController: UINavigationController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return topViewController?.preferredStatusBarStyle ?? .lightContent
  }
  
  override var prefersStatusBarHidden: Bool {
    return topViewController?.prefersStatusBarHidden ?? false
  }
  
  override var shouldAutorotate: Bool {
    return topViewController?.shouldAutorotate ?? true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return topViewController?.supportedInterfaceOrientations ?? .portrait
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
  }
  
  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    return topViewController?.preferredStatusBarUpdateAnimation ?? .slide
  }
  
  // MARK: - Navigation Bar Appearance
  
  func setupNavigationBarAppearance() {
    navigationBar.isTranslucent = false
    navigationBar.tintColor = .white
    navigationBar.backgroundColor = .appPrimary
    navigationBar.barTintColor = .appPrimary
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.titleTextAttributes = [.font: UIFont.titleFont,
                                         .foregroundColor: UIColor.white]
  }
}
