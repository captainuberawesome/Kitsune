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
    showHome()
  }
  
  private func showHome() {
    navigationController.setNavigationBarHidden(true, animated: false)
    let tabBarController = HomeTabBarController()
    tabBarController.lifecycleDelegate = self
    
    let animeListViewController = createAnimeListViewController()
    let animeListNavigationController = NavigationController(rootViewController: animeListViewController)
    animeListNavigationController.setupNavigationBarAppearance()
    
    let myLibraryViewController = createMyLibraryViewController()
    let libraryNavigationController = NavigationController(rootViewController: myLibraryViewController)
    libraryNavigationController.setupNavigationBarAppearance()
    
    tabBarController.viewControllers = [animeListNavigationController, libraryNavigationController]
    tabBarController.setupTabBarAppearance()
    
    switch presentationType {
    case .push:
      navigationController.pushViewController(tabBarController, animated: true)
    case .modalFrom(let presentingViewController):
      presentingViewController?.present(tabBarController, animated: true, completion: nil)
    }
  }
  
  private func createAnimeListViewController() -> AnimeListViewController {
    let viewModel = AnimeListViewModel(dependencies: appDependency)
    let viewController = AnimeListViewController(viewModel: viewModel)
    viewController.navigationItem.title = R.string.animeList.title()
    viewController.tabBarItem = UITabBarItem(title: R.string.animeList.title(), image: R.image.animeTopList(),
                                             selectedImage: nil)
    return viewController
  }
  
  private func createMyLibraryViewController() -> MyLibraryViewController {
    let viewModel = MyLibraryViewModel(dependencies: appDependency)
    let viewController = MyLibraryViewController(viewModel: viewModel)
    viewController.dataSource = self
    viewController.navigationItem.title = R.string.library.title()
    viewController.tabBarItem = UITabBarItem(title: R.string.library.title(), image: R.image.myLibrary(),
                                             selectedImage: nil)
    return viewController
  }
  
  private func createLoginViewController() -> LoginViewController {
    let viewModel = LoginViewModel(dependencies: appDependency)
    let viewController = LoginViewController(viewModel: viewModel)
    return viewController
  }
}

// MARK: - HomeTabBarController Delegate

extension HomeCoordinator: HomeTabBarControllerDelegate {
  func homeTabBarControllerDidDeinit(_ viewController: HomeTabBarController) {
    baseDelegate?.coordinatorRootViewControllerDidDeinit(coordinator: self)
  }
}

// MARK: - MyLibraryViewController DataSource

extension HomeCoordinator: MyLibraryViewControllerDataSource {
  func getLoginViewController() -> LoginViewController? {
    return createLoginViewController()
  }
}
