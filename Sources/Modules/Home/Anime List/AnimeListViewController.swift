//
//  HomeViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import UIKit
import UIScrollView_InfiniteScroll

private extension Constants {
  static let searchDelay: TimeInterval = 0.2
}

class AnimeListViewController: BaseViewController {
  private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  private let tableView = UITableView(frame: .zero, style: .plain)
  private let searchBar = UISearchBar()
  private let emptyView = UIView()
  private var infiniteScrollAdded = false
  private let viewModel: AnimeListViewModel
  private var searchWorkItem: DispatchWorkItem?
  
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
    setupSearchBar()
    setupTableView()
    view.addSubview(activityIndicatorView)
    activityIndicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    activityIndicatorView.isHidden = true
  }
  
  private func setupSearchBar() {
    searchBar.backgroundColor = .appPrimary
    searchBar.barTintColor = .appPrimary
    searchBar.tintColor = .appPrimary
    searchBar.barStyle = .black
    searchBar.delegate = self
    searchBar.backgroundImage = UIImage()
    searchBar.placeholder = R.string.animeList.searchBarPlaceholder()
    searchBar.enablesReturnKeyAutomatically = false
    view.addSubview(searchBar)
    searchBar.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
    }
  }
  
  private func setupTableView() {
    viewModel.dataSource.configure(withTableView: tableView)
    view.addSubview(tableView)
    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = .clear
    tableView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(searchBar.snp.bottom)
    }
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.register(AnimeListTableViewCell.self, forCellReuseIdentifier: AnimeListTableViewCell.reuseIdentifier)
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTableView(_:)))
    tableView.addGestureRecognizer(tap)
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
  
  // MARK: - Action
  
  @objc private func didTapTableView(_ sender: UIGestureRecognizer) {
    searchBar.resignFirstResponder()
  }
  
  // MARK: - Search
  
  private func search(forText text: String?) {
    guard let text = text else {
      return
    }
    self.searchWorkItem?.cancel()
    let searchWorkItem = DispatchWorkItem { [viewModel] in
      viewModel.search(forText: text)
    }
    self.searchWorkItem = searchWorkItem
    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now() + Constants.searchDelay,
                                                         execute: searchWorkItem)
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

// MARK: - UISearchBarDelegate

extension AnimeListViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    viewModel.mode = .searching
    tableView.reloadData()
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    if searchBar.text?.isEmpty != false {
      viewModel.mode = .default
      tableView.reloadData()
    }
  }
  
  func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let oldText = ((searchBar.text ?? "") as NSString)
    let newText = oldText.replacingCharacters(in: range, with: text)
    search(forText: newText)
    return true
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    if searchBar.text?.isEmpty != false {
      viewModel.mode = .default
      tableView.reloadData()
    }
  }
}
