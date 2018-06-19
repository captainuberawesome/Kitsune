//
//  MainCoordinator.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit
import SnapKit
import RxSwift

class MainCoordinator: NSObject, BaseCoordinator {

  // MARK: - Properties
  
  private let window: UIWindow
  private let appDependency: AppDependency
  private var loggingOut = false
  private var rootNavigationController = NavigationController()
  private let navigationObserver: NavigationObserver
  private let utility: MainCoordinatorUtility
  
  let disposeBag = DisposeBag()
  var onDidFinish: (() -> Void)?
  
  var presentationType: PresentationType = .push
  var parentCoordinator: BaseCoordinator?
  var childCoordinators: [BaseCoordinator] = []
 
  var topController: UIViewController {
    if let lastChild = topCoordinator {
      return lastChild.topController
    }
    var controller: UIViewController = rootNavigationController
    while let presentedController = controller.presentedViewController {
      controller = presentedController
    }
    return controller
  }
  
  // MARK: - Init
  
  required init(window: UIWindow,
                appDependency: AppDependency) {
    self.window = window
    self.appDependency = appDependency
    utility = MainCoordinatorUtility(dependencies: appDependency)
    navigationObserver = NavigationObserver(navigationController: rootNavigationController)
    super.init()
    window.rootViewController = rootNavigationController
  }
  
  // MARK: - Navigation

  func start() {
    window.makeKeyAndVisible()
    UIViewController.attemptRotationToDeviceOrientation()
    utility.start()
    rootNavigationController.setupNavigationBarAppearance()
    showHome()
  }
  
  private func showHome() {
    let coordinator = HomeCoordinator(appDependency: appDependency,
                                      logoutHandler: self,
                                      navigationController: rootNavigationController,
                                      navigationObserver: navigationObserver)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
}

// MARK: - LogoutHandler

extension MainCoordinator: LogoutHandler {
  func logout(completion: (() -> Void)?) {
    utility.signOut(completion: completion)
  }
}
