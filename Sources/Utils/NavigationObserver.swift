//
//  NavigationObserver.swift
//  Kitsune
//
//  Created by Daria Novodon on 19/06/2018.
//

import UIKit
import RxSwift

protocol NavigationPopObserver: class {
  func navigationObserver(_ observer: NavigationObserver,
                          didObserveViewControllerPop viewController: UIViewController)
  var disposeBag: DisposeBag { get }
}

class NavigationObserver: NSObject {
  private let navigationController: NavigationController
  let onViewControllerPopped = PublishSubject<UIViewController>()
  
  init(navigationController: NavigationController) {
    self.navigationController = navigationController
    super.init()
    navigationController.delegate = self
  }
  
  func addObserver(_ observer: NavigationPopObserver,
                   forPopOf viewController: UIViewController) {
    onViewControllerPopped
      .filter({ poppedController in
        poppedController === viewController
      })
      .subscribe(onNext: { [weak observer] poppedController in
        observer?.navigationObserver(self, didObserveViewControllerPop: poppedController)
      })
      .disposed(by: observer.disposeBag)
  }
}

extension NavigationObserver: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController,
                            didShow viewController: UIViewController,
                            animated: Bool) {
    guard let poppedViewController = navigationController.poppedViewController else {
      return
    }
    onViewControllerPopped.onNext(poppedViewController)
  }
  
  func navigationController(_ navigationController: UINavigationController,
                            willShow viewController: UIViewController, animated: Bool) {
    if viewController is NavigationBarHiding {
      navigationController.setNavigationBarHidden(true, animated: true)
    } else {
      navigationController.setNavigationBarHidden(false, animated: true)
    }
  }
}
