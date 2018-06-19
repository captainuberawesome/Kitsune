//
//  BaseCoordinator.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit
import RxSwift

enum PresentationType {
  case push
  case modalFrom(UIViewController?)
}

protocol BaseCoordinator: class {
  var disposeBag: DisposeBag { get }
  var childCoordinators: [BaseCoordinator] { get set }
  var onDidFinish: (() -> Void)? { get set }
  var topController: UIViewController { get }
  var topCoordinator: BaseCoordinator? { get }
  var presentationType: PresentationType { get set }

  func start()
  func start(presentationType: PresentationType)
}

extension BaseCoordinator {
  var topCoordinator: BaseCoordinator? {
    return childCoordinators.first
  }
}

extension BaseCoordinator {
  
  func start(presentationType: PresentationType) {
    self.presentationType = presentationType
    start()
  }

  func remove(child coordinator: BaseCoordinator) {
    if let index = childCoordinators.index(where: { $0 === coordinator }) {
      childCoordinators.remove(at: index)
    }
  }
  
  func addChildCoordinator(_ coordinator: BaseCoordinator) {
    coordinator.onDidFinish = { [unowned self, unowned coordinator] in
      self.removeChildCoordinator(coordinator)
    }
    childCoordinators.append(coordinator)
  }
  
  func removeChildCoordinator(_ coordinator: BaseCoordinator) {
    if let index = childCoordinators.index(where: { $0 === coordinator }) {
      childCoordinators.remove(at: index)
    }
  }
}
