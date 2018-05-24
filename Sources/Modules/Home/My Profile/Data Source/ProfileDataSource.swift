//
//  ProfileDataSource.swift
//  Kitsune
//
//  Created by Daria Novodon on 24/05/2018.
//

import UIKit

class ProfileDataSource: NSObject {
  
  // MARK: - Properties
  private var items: [ProfileCellViewModel] = []
  private var titles: [ProfileCellViewModel.InfoType: String?] = [.gender: R.string.profile.gender(),
                                                                  .location: R.string.profile.location(),
                                                                  .birthday: R.string.profile.birthday(),
                                                                  .joinDate: R.string.profile.joinDate()]
  private var icons: [ProfileCellViewModel.InfoType: UIImage?] = [.gender: R.image.genderIcon(),
                                                                  .location: R.image.locationIcon(),
                                                                  .birthday: R.image.birthdayIcon(),
                                                                  .joinDate: R.image.dateIcon()]
  private var tableView: UITableView?
  
  func configure(withTableView tableView: UITableView) {
    self.tableView = tableView
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  func updateData(with viewModel: MyProfileViewModel) {
    items = viewModel.cellViewModels
  }
  
  private func item(at indexPath: IndexPath) -> ProfileCellViewModel? {
    guard indexPath.row < items.count else { return nil }
    return items[indexPath.row]
  }
}

// MARK: - UITableViewDataSource

extension ProfileDataSource: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let viewModel = item(at: indexPath) else { return UITableViewCell() }
    let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellReuseIdentifier, for: indexPath)
    cell.selectionStyle = .none
    if let profileCell = cell as? ProfileCell, let icon = icons[viewModel.infoType] as? UIImage,
      let title = titles[viewModel.infoType] as? String {
      profileCell.configure(withIcon: icon, title: title, value: viewModel.value)
    }
    return cell
  }
}

// MARK: - UITableViewDelegate

extension ProfileDataSource: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
}
