//
//  AnimeDetailsCoordinator.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/06/2018.
//

import UIKit
import RxSwift

class AnimeDetailsCoordinator: NavigationFlowCoordinator {
  private let appDependency: AppDependency
  private let anime: Anime
  private let navigationObserver: NavigationObserver
  
  let disposeBag = DisposeBag()
  var onDidFinish: (() -> Void)?
  
  var navigationController: UINavigationController
  var childCoordinators: [BaseCoordinator] = []
  var presentationType: PresentationType = .push
  
  init(anime: Anime, appDependency: AppDependency, navigationController: UINavigationController,
       navigationObserver: NavigationObserver) {
    self.anime = anime
    self.appDependency = appDependency
    self.navigationController = navigationController
    self.navigationObserver = navigationObserver
  }
  
  // MARK: - Navigation
  
  func start() {
    showAnimeDetails(anime: anime, isStarting: true)
  }
  
  private func showAnimeDetails(anime: Anime, isStarting: Bool = false) {
    let viewModel = AnimeDetailsViewModel(anime: anime)
    let viewController = AnimeDetailsViewController(viewModel: viewModel)
    viewController.hidesBottomBarWhenPushed = true
    viewController.title = R.string.animeDetails.title()
    
    if isStarting {
      navigationObserver.addObserver(self, forPopOf: viewController)
    }
    
    switch presentationType {
    case .push:
      if navigationController.viewControllers.isEmpty == false {
        viewController.navigationItem.leftBarButtonItem = createBackButton()
      }
      navigationController.pushViewController(viewController, animated: true)
    case .modalFrom(let presentingViewController):
      navigationController.pushViewController(viewController, animated: false)
      presentingViewController?.present(navigationController, animated: true, completion: nil)
    }
  }
}
