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
  
  private var onDatabaseUpdated: (() -> Void)?
  
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
    utility.updateDataBase {
      self.onDatabaseUpdated?()
    }
    window.makeKeyAndVisible()
    UIViewController.attemptRotationToDeviceOrientation()
    utility.start()
    if utility.isLoggedIn {
      didLogIn()
    } else {
      showAuthorization()
    }
  }
  
  private func didLogIn() {
    showHome()
  }
  
  private func showAuthorization() {
    childCoordinators = []
    let authCoordinator = AuthCoordinator(appDependency: appDependency, navigationController: rootNavigationController)
    addChildCoordinator(authCoordinator)
    authCoordinator.start()
  }
  
  private func showHome() {
//    childCoordinators = []
//    let coordinator =
//    onDatabaseUpdated = { [weak coordinator] in
//      coordinator?.handleDatabaseUpdate()
//    }
//    addChildCoordinator(coordinator)
//    rootNavigationController.viewControllers = []
//    coordinator.start()
  }
  
  // MARK: - Change Root Controller
  
  private func resetCoordinatorsToAuth() {
    childCoordinators = []
    utility.clearUserData {
      self.rootNavigationController = NavigationController()
      self.showAuthorization()
      self.changeRootViewController(of: self.window, to: self.rootNavigationController)
      self.loggingOut = false
    }
  }
  
  private func changeRootViewController(of window: UIWindow,
                                        to viewController: UIViewController,
                                        animationDuration: TimeInterval = 0.5) {
    let animations = {
      window.rootViewController = self.rootNavigationController
    }
    UIView.transition(with: window, duration: animationDuration, options: .transitionFlipFromLeft,
                      animations: animations, completion: nil)
  }
}

// MARK: - LogoutHandler

extension MainCoordinator: LogoutHandler {
  private func resetToAuth() {
    loggingOut = true
    resetCoordinatorsToAuth()
  }
  
  func handleAuthorizationError(error: NSError) {
    self.resetCoordinatorsToAuth()
  }
  
  func logout() {
    guard !loggingOut else { return }
    loggingOut = true
    utility.signOut { _ in
      self.resetToAuth()
    }
  }
}
