//
//  HomeCoordinator.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import UIKit
import RxSwift

class HomeCoordinator: NavigationFlowCoordinator {
  private let appDependency: AppDependency
  private let navigationObserver: NavigationObserver
  
  let disposeBag = DisposeBag()
  var onDidFinish: (() -> Void)?
  
  var navigationController: UINavigationController
  var childCoordinators: [BaseCoordinator] = []
  var presentationType: PresentationType = .push
  weak var logoutHandler: LogoutHandler?
  
  private var onDidFinishLogin: (() -> Void)?
  
  init(appDependency: AppDependency, logoutHandler: LogoutHandler,
       navigationController: UINavigationController, navigationObserver: NavigationObserver) {
    self.appDependency = appDependency
    self.logoutHandler = logoutHandler
    self.navigationController = navigationController
    self.navigationObserver = navigationObserver
  }
  
  // MARK: - Navigation
  
  func start() {
    showHome(isStarting: true)
  }
  
  private func showHome(isStarting: Bool = false) {
    navigationController.setNavigationBarHidden(true, animated: false)
    let tabBarController = HomeTabBarController()
    
    let animeListViewController = createAnimeListViewController()
    let animeListNavigationController = NavigationController(rootViewController: animeListViewController)
    animeListNavigationController.setupNavigationBarAppearance()
    
    let myProfileViewController = createMyProfileViewController()
    let myProfileNavigationController = NavigationController(rootViewController: myProfileViewController)
    myProfileNavigationController.setupNavigationBarAppearance()
    
    tabBarController.viewControllers = [animeListNavigationController, myProfileNavigationController]
    tabBarController.setupTabBarAppearance()
    
    if isStarting {
      navigationObserver.addObserver(self, forPopOf: tabBarController)
    }
    
    switch presentationType {
    case .push:
      navigationController.pushViewController(tabBarController, animated: true)
    case .modalFrom(let presentingViewController):
      navigationController.pushViewController(tabBarController, animated: false)
      presentingViewController?.present(navigationController, animated: true, completion: nil)
    }
  }
  
  private func showDetails(anime: Anime) {
    let coordinator = AnimeDetailsCoordinator(anime: anime,
                                              appDependency: appDependency,
                                              navigationController: navigationController,
                                              navigationObserver: navigationObserver)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  // MARK: - Create View Controllers
  
  private func createAnimeListViewController() -> AnimeListViewController {
    let viewModel = AnimeListViewModel(dependencies: appDependency)
    viewModel.onSelected
      .subscribe(onNext: { [unowned self] anime in
        self.showDetails(anime: anime)
      })
      .disposed(by: disposeBag)
    let viewController = AnimeListViewController(viewModel: viewModel)
    viewController.navigationItem.title = R.string.animeList.title()
    viewController.tabBarItem = UITabBarItem(title: R.string.animeList.title(), image: R.image.listIcon(),
                                             selectedImage: nil)
    return viewController
  }
  
  private func createMyProfileViewController() -> MyProfileViewController {
    let viewModel = MyProfileViewModel(dependencies: appDependency)
    let viewController = MyProfileViewController(viewModel: viewModel)
    viewController.dataSource = self
    viewController.navigationItem.title = R.string.profile.title()
    viewController.tabBarItem = UITabBarItem(title: R.string.profile.title(), image: R.image.profileIcon(),
                                             selectedImage: nil)
    let logoutButton = UIBarButtonItem(title: R.string.profile.logoutButtonTitle(), style: .plain,
                                       target: nil, action: nil)
    logoutButton.setTitleTextAttributes([.font: UIFont.textFont], for: .normal)
    logoutButton.setTitleTextAttributes([.font: UIFont.textFont], for: .highlighted)
    logoutButton
      .rx.tap
      .subscribe(onNext: { [unowned self, weak viewController] in
        self.logoutHandler?.logout {
          viewController?.navigationItem.rightBarButtonItem = nil
          viewController?.configureForLoggedOut()
        }
      })
      .disposed(by: disposeBag)
    if viewModel.isLoggedIn {
      viewController.navigationItem.rightBarButtonItem = logoutButton
    }
    onDidFinishLogin = { [weak viewController, logoutButton] in
      viewController?.navigationItem.rightBarButtonItem = logoutButton
      viewController?.configureForLoggedIn()
    }
    return viewController
  }
  
  private func createLoginViewController() -> LoginViewController {
    let viewModel = LoginViewModel(dependencies: appDependency)
    viewModel.onDidFinishLogin
      .subscribe(onNext: { [weak self] in
        self?.onDidFinishLogin?()
      })
    .disposed(by: disposeBag)
    let viewController = LoginViewController(viewModel: viewModel)
    return viewController
  }
}

// MARK: - MyProfileViewController DataSource

extension HomeCoordinator: MyProfileViewControllerDataSource {
  func getLoginViewController() -> LoginViewController? {
    return createLoginViewController()
  }
}
