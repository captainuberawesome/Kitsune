//
//  NavigationFlowCoordinator.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit
import RxSwift
import RxCocoa

protocol NavigationFlowCoordinator: BaseCoordinator, NavigationPopObserver {
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
  
  private func removeLastChild() {
    if childCoordinators.isEmpty {
      onDidFinish?()
    } else {
      childCoordinators.removeLast()
    }
  }
  
  // MARK: - Create back / close buttons
  
  func createBackButton(tapHandler: (() -> Void)? = nil) -> UIBarButtonItem {
    let button = UIBarButtonItem(image: R.image.backIcon(), style: .plain, target: nil, action: nil)
    button.rx.tap
      .subscribe(onNext: { [unowned self] in
        self.navigationController.popViewController(animated: true)
        tapHandler?()
      }).disposed(by: disposeBag)
    return button
  }
  
  func createCloseButton(tapHandler: (() -> Void)? = nil) -> UIBarButtonItem {
    let button = UIBarButtonItem(image: R.image.closeIcon(), style: .plain, target: nil, action: nil)
    button.rx.tap
      .subscribe(onNext: { [unowned self] in
        self.navigationController.dismiss(animated: true, completion: {
          self.removeLastChild()
          tapHandler?()
        })
      }).disposed(by: disposeBag)
    return button
  }
}

// MARK: - NavigationPopObserver

extension NavigationFlowCoordinator {
  func navigationObserver(_ observer: NavigationObserver, didObserveViewControllerPop viewController: UIViewController) {
    removeLastChild()
  }
}
