//
//  HomeViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import UIKit
import UIScrollView_InfiniteScroll

class AnimeListViewController: BaseViewController {
  private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  private let tableView = UITableView(frame: .zero, style: .plain)
  private let emptyView = UIView()
  private var infiniteScrollAdded = false
  private let viewModel: AnimeListViewModel
  
  // MARK: - Init
  
  required init(viewModel: AnimeListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    bindViewModel()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    viewModel.reloadData()
  }
  
  // MARK: - Setup
  
  private func setup() {
    view.backgroundColor = .white
    setupTableView()
    view.addSubview(activityIndicatorView)
    activityIndicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    activityIndicatorView.isHidden = true
  }
  
  private func setupTableView() {
    viewModel.dataSource.configure(withTableView: tableView)
    view.addSubview(tableView)
    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = .clear
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.register(AnimeListTableViewCell.self, forCellReuseIdentifier: AnimeListTableViewCell.reuseIdentifier)
  }
  
  // MARK: - View Model
  
  private func bindViewModel() {
    viewModel.onLoadingStarted = { [weak self, unowned viewModel] in
      self?.emptyView.isHidden = true
      if !viewModel.hasData && self?.tableView.isAnimatingInfiniteScroll != true {
        self?.activityIndicatorView.isHidden = false
        self?.activityIndicatorView.startAnimating()
      }
    }
    viewModel.onLoadingFinished = { [weak self] in
      self?.activityIndicatorView.isHidden = true
      self?.activityIndicatorView.stopAnimating()
      self?.finishInfiniteScroll()
    }
    viewModel.onErrorEncountered = { [weak self] error in
      self?.emptyView.isHidden = false
    }
    viewModel.onUIReloadRequested = { [weak self] in
      self?.tableView.reloadData()
      self?.updateInfiniteScrollView()
    }
  }
}

// MARK: Infinite scroll

extension AnimeListViewController {
  private func addInfiniteScroll() {
    if infiniteScrollAdded {
      return
    }
    tableView.infiniteScrollIndicatorStyle = .gray
    infiniteScrollAdded = true
    tableView.addInfiniteScroll { [weak self] _ in
      self?.viewModel.loadNextPage()
    }
  }
  
  private func removeInfiniteScroll() {
    infiniteScrollAdded = false
    tableView.removeInfiniteScroll()
  }
  
  private func finishInfiniteScroll() {
    tableView.finishInfiniteScroll()
  }
  
  private func updateInfiniteScrollView() {
    if viewModel.canLoadMorePages {
      addInfiniteScroll()
    } else {
      removeInfiniteScroll()
    }
  }
}
