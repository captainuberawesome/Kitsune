//
//  AnimeDetailsCoordinator.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/06/2018.
//

import UIKit
import RxSwift

class AnimeDetailsCoordinator: NavigationFlowCoordinator {
  private(set) var onRootControllerDidDeinit = PublishSubject<Void>()
  private let appDependency: AppDependency
  private let anime: Anime
  let disposeBag = DisposeBag()
  
  var navigationController: UINavigationController
  var childCoordinators: [BaseCoordinator] = []
  var presentationType: PresentationType = .push
  
  init(anime: Anime, appDependency: AppDependency, navigationController: UINavigationController) {
    self.anime = anime
    self.appDependency = appDependency
    self.navigationController = navigationController
  }
  
  // MARK: - Navigation
  
  func start() {
    showAnimeDetails(anime: anime)
  }
  
  private func showAnimeDetails(anime: Anime) {
    let viewModel = AnimeDetailsViewModel(anime: anime)
    let viewController = AnimeDetailsViewController(viewModel: viewModel)
    viewController.hidesBottomBarWhenPushed = true
    viewController.title = R.string.animeDetails.title()
    switch presentationType {
    case .push:
      navigationController.pushViewController(viewController, animated: true)
    case .modalFrom(let presentingViewController):
      navigationController.pushViewController(viewController, animated: false)
      presentingViewController?.present(navigationController, animated: true, completion: nil)
    }
  }
}
