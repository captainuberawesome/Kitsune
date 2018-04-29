//
//  NavigationFlowCoordinator.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit

protocol NavigationFlowCoordinator: BaseCoordinator {
  var navigationController: UINavigationController { get }
}

extension NavigationFlowCoordinator {
  var topController: UIViewController {
    if let lastChild = topCoordinator {
      return lastChild.topController
    }
    var presentedController: UIViewController? = navigationController.presentedViewController
    
    while let presentedViewController = presentedController?.presentedViewController {
      presentedController = presentedViewController
    }
    
    while presentedController is UIAlertController {
      presentedController = presentedController?.presentingViewController
    }
        
    if let navigationViewController = presentedController as? UINavigationController {
      presentedController = navigationViewController.topViewController
    }
    
    return (presentedController ?? navigationController.topViewController) ?? navigationController
  }
}
