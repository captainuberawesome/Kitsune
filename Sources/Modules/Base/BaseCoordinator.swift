//
//  BaseCoordinator.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit

protocol BaseCoordinatorDelegate: class {
  func coordinatorRootViewControllerDidDeinit(coordinator: BaseCoordinator)
}

enum PresentationType {
  case push
  case modalFrom(UIViewController?)
}

protocol BaseCoordinator: BaseCoordinatorDelegate {
  
  var childCoordinators: [BaseCoordinator] { get set }
  var baseDelegate: BaseCoordinatorDelegate? { get set }
  var topController: UIViewController { get }
  var topCoordinator: BaseCoordinator? { get }
  var presentationType: PresentationType { get }

  func start(presentationType: PresentationType)
}

extension BaseCoordinator {
  var topCoordinator: BaseCoordinator? {
    return childCoordinators.first
  }
}

extension BaseCoordinator {
  
  func start() {
    return start(presentationType: .push)
  }

  func remove(child coordinator: BaseCoordinator) {
    if let index = childCoordinators.index(where: { $0 === coordinator }) {
      childCoordinators.remove(at: index)
    }
  }

  func dismissModalControllers(_ completion: (() -> Void)?) {
    if let presentingViewController = topController.presentingViewController {
      presentingViewController.dismiss(animated: true, completion: { [unowned self] in
        self.dismissModalControllers(completion)
      })
    } else {
      completion?()
    }
  }

  func addChildCoordinator(_ coordinator: BaseCoordinator) {
    childCoordinators.append(coordinator)
    coordinator.baseDelegate = self
  }

  func coordinatorRootViewControllerDidDeinit(coordinator: BaseCoordinator) {
    remove(child: coordinator)
  }
}
