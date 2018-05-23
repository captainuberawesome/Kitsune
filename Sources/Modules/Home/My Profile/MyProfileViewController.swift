//
//  MyProfileViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import UIKit

protocol MyProfileViewControllerDataSource: class {
  func getLoginViewController() -> LoginViewController?
}

class MyProfileViewController: BaseViewController {
  
  private let loginContainerView = UIView()
  private var loginViewController: LoginViewController?
  private let viewModel: MyProfileViewModel
  
  weak var dataSource: MyProfileViewControllerDataSource?
  
  // MARK: - Init
  
  required init(viewModel: MyProfileViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    bindViewModel()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if !viewModel.isLoggedIn {
      addLoginViewController()
    } else {
      viewModel.loadCachedData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if viewModel.isLoggedIn {
      viewModel.reloadData()
    }
  }
  
  // MARK: - Configure

  private func addLoginViewController() {
    guard let loginViewController = dataSource?.getLoginViewController() else { return }
    self.loginViewController = loginViewController
    view.addSubview(loginContainerView)
    loginContainerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    addChildViewController(loginViewController, toView: loginContainerView)
  }
  
  // MARK: - Public
  
  func configureForLoggedIn() {
    guard let loginViewController = self.loginViewController else { return }
    removeChildController(loginViewController)
    loginContainerView.removeFromSuperview()
    viewModel.reloadData()
  }
  
  func configureForLoggedOut() {
    addLoginViewController()
  }
  
  // MARK: - View Model
  
  private func bindViewModel() {

  }
}
