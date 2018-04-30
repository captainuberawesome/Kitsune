//
//  AuthCoordinator.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit

class AuthCoordinator: NavigationFlowCoordinator {
  
  private let appDependency: AppDependency
  
  var navigationController: UINavigationController
  var childCoordinators: [BaseCoordinator] = []
  var presentationType: PresentationType = .push
  weak var baseDelegate: BaseCoordinatorDelegate?
  
  init(appDependency: AppDependency, navigationController: UINavigationController) {
    self.appDependency = appDependency
    self.navigationController = navigationController
  }
  
  // MARK: - Navigation
  
  func start() {
    showAuthScreen()
  }
  
  private func showAuthScreen() {
    let viewModel = AuthViewModel(dependencies: appDependency)
    let viewController = AuthViewController(viewModel: viewModel)
    switch presentationType {
    case .push:
      navigationController.pushViewController(viewController, animated: true)
    case .modalFrom(let presentingViewController):
      presentingViewController?.present(navigationController, animated: true, completion: nil)
    }
  }
}
