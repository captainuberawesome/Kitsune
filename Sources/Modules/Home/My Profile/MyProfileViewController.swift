//
//  MyProfileViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import UIKit
import RxSwift

protocol MyProfileViewControllerDataSource: class {
  func getLoginViewController() -> LoginViewController?
}

private extension Constants {
  static var titles: [ProfileCellViewModel.InfoType: String?] = [.gender: R.string.profile.gender(),
                                                                 .location: R.string.profile.location(),
                                                                 .birthday: R.string.profile.birthday(),
                                                                 .joinDate: R.string.profile.joinDate()]
  static var icons: [ProfileCellViewModel.InfoType: UIImage?] = [.gender: R.image.genderIcon(),
                                                                 .location: R.image.locationIcon(),
                                                                 .birthday: R.image.birthdayIcon(),
                                                                 .joinDate: R.image.dateIcon()]
}

class MyProfileViewController: BaseViewController {
  
  private let loginContainerView = UIView()
  private var loginViewController: LoginViewController?
  private let profileHeaderView = ProfileHeaderView()
  private let tableView = UITableView()
  private let viewModel: MyProfileViewModel
  private let disposeBag = DisposeBag()
  
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
    view.layoutIfNeeded()
    view.addSubview(profileHeaderView)
    profileHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.height * 0.35)
    tableView.tableHeaderView = profileHeaderView
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.showsVerticalScrollIndicator = false
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
    
    bindTableView()
  }
  
  private func bindTableView() {
    viewModel.cellViewModels
      .bind(to: tableView.rx.items(cellIdentifier: ProfileCell.reuseIdentifier,
                                   cellType: ProfileCell.self)) { _, cellViewModel, cell in
        if let icon = Constants.icons[cellViewModel.infoType] as? UIImage,
          let title = Constants.titles[cellViewModel.infoType] as? String {
          cell.configure(withIcon: icon, title: title, value: cellViewModel.value)
        }
        cell.selectionStyle = .none
      }
      .disposed(by: disposeBag)
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
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
    viewModel.state
      .subscribe(onError: { [weak self] error in
        self?.handle(error: error)
      })
      .disposed(by: disposeBag)
    viewModel.onUserUpdated
      .subscribe(onNext: { [weak self, unowned viewModel] in
        self?.profileHeaderView.configure(viewModel: viewModel)
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Public
  
  func configureForLoggedIn() {
    guard let loginViewController = self.loginViewController else { return }
    removeChildController(loginViewController)
    self.loginViewController = nil
    loginContainerView.removeFromSuperview()
    viewModel.reloadData()
  }
  
  func configureForLoggedOut() {
    addLoginViewController()
  }
}

// MARK: - UITableViewDelegate

extension MyProfileViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
}
