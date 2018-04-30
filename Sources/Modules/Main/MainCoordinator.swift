//
//  MainCoordinator.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit
import SnapKit

class MainCoordinator: NSObject, BaseCoordinator {
  // MARK: - Properties
  
  private let window: UIWindow
  private let appDependency: AppDependency
  private var loggingOut = false
  private var rootNavigationController = NavigationController()
  private let utility: MainCoordinatorUtility
  
  var presentationType: PresentationType = .push
  var parentCoordinator: BaseCoordinator?
  var childCoordinators: [BaseCoordinator] = []
  weak var baseDelegate: BaseCoordinatorDelegate?
 
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
    self.utility = MainCoordinatorUtility(dependencies: appDependency)
    super.init()
    window.rootViewController = rootNavigationController
    rootNavigationController.navigationBar.isTranslucent = false
  }
  
  // MARK: - Navigation

  func start() {
    window.makeKeyAndVisible()
    UIViewController.attemptRotationToDeviceOrientation()
    utility.start()
    showHome()
  }
  
  private func showHome() {
    childCoordinators = []
    let coordinator = HomeCoordinator(appDependency: appDependency, navigationController: rootNavigationController)
    addChildCoordinator(coordinator)
    rootNavigationController.viewControllers = []
    coordinator.start()
  }
}

// MARK: - LogoutHandler

extension MainCoordinator: LogoutHandler {
  func logout() {
    utility.signOut()
  }
}
