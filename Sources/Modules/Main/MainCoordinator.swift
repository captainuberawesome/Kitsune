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
  private let utility: MainCoordinatorUtility
  
  let disposeBag = DisposeBag()
  private(set) var onRootControllerDidDeinit = PublishSubject<Void>()
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
    self.utility = MainCoordinatorUtility(dependencies: appDependency)
    super.init()
    window.rootViewController = rootNavigationController
    rootNavigationController.delegate = self
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
    let coordinator = HomeCoordinator(appDependency: appDependency, logoutHandler: self,
                                      navigationController: rootNavigationController)
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

extension MainCoordinator: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController,
                            willShow viewController: UIViewController, animated: Bool) {
    if viewController is NavigationBarHiding {
      navigationController.setNavigationBarHidden(true, animated: true)
    } else {
      navigationController.setNavigationBarHidden(false, animated: true)
    }
  }
}
