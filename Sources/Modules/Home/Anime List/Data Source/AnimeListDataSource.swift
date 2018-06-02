//
//  AnimeListDataSource.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import UIKit
import RxSwift

class AnimeListDataSource: NSObject {
  
  // MARK: - Properties
  private var items: [AnimeCellViewModel] = []
  private var tableView: UITableView?
  private let disposeBag = DisposeBag()
  
  func configure(withTableView tableView: UITableView, viewModel: AnimeListViewModel) {
    self.tableView = tableView
    tableView.dataSource = self
    tableView.delegate = self
    viewModel.cellViewModels.asObservable()
      .subscribe(onNext: { [weak self] cellViewModels in
        self?.items = cellViewModels
      })
      .disposed(by: disposeBag)
  }
  
  private func item(at indexPath: IndexPath) -> AnimeCellViewModel? {
    guard indexPath.row < items.count else { return nil }
    return items[indexPath.row]
  }
}

// MARK: - UITableViewDataSource

extension AnimeListDataSource: UITableViewDataSource {
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
    if let animeCell = cell as? AnimeListTableViewCell {
      animeCell.configure(viewModel: viewModel)
    }
    return cell
  }
}

// MARK: - UITableViewDelegate

extension AnimeListDataSource: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
}
