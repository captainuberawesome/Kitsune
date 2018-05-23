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
  weak var logoutHandler: LogoutHandler?
  
  var onFinishedLogin: (() -> Void)?
  var onLoggedOut: (() -> Void)?
  
  init(appDependency: AppDependency, logoutHandler: LogoutHandler, navigationController: UINavigationController) {
    self.appDependency = appDependency
    self.logoutHandler = logoutHandler
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
    
    let myProfileViewController = createMyProfileViewController()
    let myProfileNavigationController = NavigationController(rootViewController: myProfileViewController)
    myProfileNavigationController.setupNavigationBarAppearance()
    
    tabBarController.viewControllers = [animeListNavigationController, myProfileNavigationController]
    tabBarController.setupTabBarAppearance()
    
    switch presentationType {
    case .push:
      navigationController.pushViewController(tabBarController, animated: true)
    case .modalFrom(let presentingViewController):
      presentingViewController?.present(tabBarController, animated: true, completion: nil)
    }
  }
  
  // MARK: - Create View Controllers
  
  private func createAnimeListViewController() -> AnimeListViewController {
    let viewModel = AnimeListViewModel(dependencies: appDependency)
    let viewController = AnimeListViewController(viewModel: viewModel)
    viewController.navigationItem.title = R.string.animeList.title()
    viewController.tabBarItem = UITabBarItem(title: R.string.animeList.title(), image: R.image.animeTopList(),
                                             selectedImage: nil)
    return viewController
  }
  
  private func createMyProfileViewController() -> MyProfileViewController {
    let viewModel = MyProfileViewModel(dependencies: appDependency)
    let viewController = MyProfileViewController(viewModel: viewModel)
    viewController.dataSource = self
    viewController.navigationItem.title = R.string.profile.title()
    viewController.tabBarItem = UITabBarItem(title: R.string.profile.title(), image: R.image.myProfile(),
                                             selectedImage: nil)
    let logoutButton = UIBarButtonItem(title: R.string.profile.logoutButtonTitle(), style: .plain,
                                       target: self, action: #selector(self.logoutButtonTapped(_:)))
    logoutButton.setTitleTextAttributes([.font: UIFont.textFont], for: .normal)
    logoutButton.setTitleTextAttributes([.font: UIFont.textFont], for: .highlighted)
    if viewModel.isLoggedIn {
      viewController.navigationItem.rightBarButtonItem = logoutButton
    }
    onFinishedLogin = { [weak viewController, logoutButton] in
      viewController?.navigationItem.rightBarButtonItem = logoutButton
      viewController?.configureForLoggedIn()
    }
    onLoggedOut = { [weak viewController] in
      viewController?.navigationItem.rightBarButtonItem = nil
      viewController?.configureForLoggedOut()
    }
    return viewController
  }
  
  private func createLoginViewController() -> LoginViewController {
    let viewModel = LoginViewModel(dependencies: appDependency)
    viewModel.delegate = self
    let viewController = LoginViewController(viewModel: viewModel)
    return viewController
  }
  
  // MARK: - Actions
  
  @objc private func logoutButtonTapped(_ sender: UIBarButtonItem) {
    logoutHandler?.logout {
      self.onLoggedOut?()
    }
  }
}

// MARK: - HomeTabBarController Delegate

extension HomeCoordinator: HomeTabBarControllerDelegate {
  func homeTabBarControllerDidDeinit(_ viewController: HomeTabBarController) {
    baseDelegate?.coordinatorRootViewControllerDidDeinit(coordinator: self)
  }
}

// MARK: - MyProfileViewController DataSource

extension HomeCoordinator: MyProfileViewControllerDataSource {
  func getLoginViewController() -> LoginViewController? {
    return createLoginViewController()
  }
}

// MARK: - LoginViewModel Delegate

extension HomeCoordinator: LoginViewModelDelegate {
  func loginViewModelDidFinishLogin(_ viewModel: LoginViewModel) {
    onFinishedLogin?()
  }
}
