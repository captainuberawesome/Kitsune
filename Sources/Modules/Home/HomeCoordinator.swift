//
//  HomeCoordinator.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import UIKit

class HomeCoordinator: NavigationFlowCoordinator {
  
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
    showAnimeListScreen()
  }
  
  private func showAnimeListScreen() {
    let viewModel = AnimeListViewModel(dependencies: appDependency)
    let viewController = AnimeListViewController(viewModel: viewModel)
    viewController.navigationItem.title = R.string.animeList.title()
    switch presentationType {
    case .push:
      navigationController.pushViewController(viewController, animated: true)
    case .modalFrom(let presentingViewController):
      presentingViewController?.present(navigationController, animated: true, completion: nil)
    }
  }
}
