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
  private let profileHeaderView = ProfileHeaderView()
  private let tableView = UITableView()
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
    setup()
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
  
  // MARK: - Setup
  
  private func setup() {
    view.backgroundColor = .white
    setupTableView()
    setupProfileHeaderView()
  }
  
  private func setupProfileHeaderView() {
    view.addSubview(profileHeaderView)
    profileHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: view.frame.height * 0.35)
    tableView.tableHeaderView = profileHeaderView
  }
  
  private func setupTableView() {
    viewModel.dataSource.configure(withTableView: tableView)
    view.addSubview(tableView)
    tableView.showsVerticalScrollIndicator = false
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
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
    viewModel.onUIReloadRequested = { [weak self, unowned viewModel] in
      self?.profileHeaderView.configure(viewModel: viewModel)
      self?.tableView.reloadData()
    }
  }
}
