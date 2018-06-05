//
//  ProfileDataSource.swift
//  Kitsune
//
//  Created by Daria Novodon on 24/05/2018.
//

import UIKit
import RxSwift

class ProfileDataSource: NSObject {
  
  // MARK: - Properties
  private let disposeBag = DisposeBag()
  private var titles: [ProfileCellViewModel.InfoType: String?] = [.gender: R.string.profile.gender(),
                                                                  .location: R.string.profile.location(),
                                                                  .birthday: R.string.profile.birthday(),
                                                                  .joinDate: R.string.profile.joinDate()]
  private var icons: [ProfileCellViewModel.InfoType: UIImage?] = [.gender: R.image.genderIcon(),
                                                                  .location: R.image.locationIcon(),
                                                                  .birthday: R.image.birthdayIcon(),
                                                                  .joinDate: R.image.dateIcon()]
  private var tableView: UITableView?
  
  func configure(withTableView tableView: UITableView, viewModel: MyProfileViewModel) {
    self.tableView = tableView
    viewModel.cellViewModels
      .bind(to: tableView.rx.items(cellIdentifier: ProfileCell.reuseIdentifier,
                                   cellType: ProfileCell.self)) { _, cellViewModel, cell in
        if let icon = self.icons[cellViewModel.infoType] as? UIImage,
        let title = self.titles[cellViewModel.infoType] as? String {
          cell.configure(withIcon: icon, title: title, value: cellViewModel.value)
        }
        cell.selectionStyle = .none
      }
      .disposed(by: disposeBag)
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }
}

// MARK: - UITableViewDelegate

extension ProfileDataSource: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
}
