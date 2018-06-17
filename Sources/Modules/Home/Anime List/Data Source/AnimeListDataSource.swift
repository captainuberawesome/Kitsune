//
//  AnimeListDataSource.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import UIKit
import RxSwift

extension Constants {
  static let estimatedRowHeight: CGFloat = 143
}

class AnimeListDataSource: NSObject {
  
  // MARK: - Properties
  private var tableView: UITableView?
  private let disposeBag = DisposeBag()
  
  func configure(withTableView tableView: UITableView, viewModel: AnimeListViewModel) {
    self.tableView = tableView
    viewModel.cellViewModels
      .skip(1)
      .bind(to: tableView.rx.items(cellIdentifier: AnimeListTableViewCell.reuseIdentifier,
                                   cellType: AnimeListTableViewCell.self)) { _, cellViewModel, cell in
         cell.configure(viewModel: cellViewModel)
         cell.selectionStyle = .none
      }
      .disposed(by: disposeBag)
    
    tableView
      .rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    tableView
      .rx
      .modelSelected(AnimeCellViewModel.self)
      .subscribe(onNext: { cellViewModel in
        cellViewModel.select()
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - UITableViewDelegate

extension AnimeListDataSource: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.estimatedRowHeight
  }
}
