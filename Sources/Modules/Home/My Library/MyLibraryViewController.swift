//
//  MyLibraryViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import UIKit

protocol MyLibraryViewControllerDataSource: class {
  func getLoginViewController() -> LoginViewController?
}

class MyLibraryViewController: BaseViewController {
  
  private let loginContainerView = UIView()
  private var loginViewController: LoginViewController?
  private let viewModel: MyLibraryViewModel
  
  weak var dataSource: MyLibraryViewControllerDataSource?
  
  // MARK: - Init
  
  required init(viewModel: MyLibraryViewModel) {
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
  
  // MARK: - View Model
  
  private func bindViewModel() {
    
  }
}
