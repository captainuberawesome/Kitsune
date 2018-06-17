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
  var onRootControllerDidDeinit: PublishSubject<Void> { get }
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
    childCoordinators.append(coordinator)
    coordinator.onRootControllerDidDeinit
      .subscribe(onCompleted: { [unowned self] in
        self.remove(child: coordinator)
      })
      .disposed(by: disposeBag)
  }
}
