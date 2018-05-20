//
//  HomeTabBarController.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import UIKit

protocol HomeTabBarControllerDelegate: class {
  func homeTabBarControllerDidDeinit(_ viewController: HomeTabBarController)
}

class HomeTabBarController: TabBarController {
  
  weak var lifecycleDelegate: HomeTabBarControllerDelegate?
  
  deinit {
    lifecycleDelegate?.homeTabBarControllerDidDeinit(self)
  }
  
  func setupTabBarAppearance() {
    tabBar.isTranslucent = false
    tabBar.backgroundColor = .appPrimary
    tabBar.tintColor = .white
    tabBar.barTintColor = .appPrimary
    tabBar.shadowImage = UIImage()
    tabBar.backgroundImage = UIImage()
    tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
  }
}
