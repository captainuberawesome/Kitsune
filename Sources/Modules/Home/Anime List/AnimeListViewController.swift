//
//  HomeViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import UIKit
import RxCocoa
import RxSwift
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
  private let disposeBag = DisposeBag()
  
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
    // TODO: setup empty view for error
  }
  
  private func setupSearchBar() {
    searchBar.backgroundColor = .appPrimary
    searchBar.barTintColor = .appPrimary
    searchBar.tintColor = .appPrimary
    searchBar.barStyle = .black
    searchBar.backgroundImage = UIImage()
    searchBar.placeholder = R.string.animeList.searchBarPlaceholder()
    searchBar.enablesReturnKeyAutomatically = false
    view.addSubview(searchBar)
    searchBar.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
    }
    observeSearchBar()
  }
  
  private func observeSearchBar() {
    searchBar
      .rx.text
      .orEmpty
      .debounce(Constants.searchDelay, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
      .distinctUntilChanged()
      .subscribe(onNext: { [unowned self] query in
        if query.isEmpty {
          self.viewModel.mode = .default
          self.tableView.reloadData()
          return
        }
        self.viewModel.mode = .searching
        self.viewModel.search(forText: query)
      })
      .disposed(by: disposeBag)
    
    searchBar.rx.searchButtonClicked.subscribe(onNext: { [unowned self] in
      if self.searchBar.text?.isEmpty != false {
        self.viewModel.mode = .default
        self.tableView.reloadData()
      }
      self.searchBar.resignFirstResponder()
    }).disposed(by: disposeBag)
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
    viewModel.stateSubject
      .subscribe(onNext: { [weak self, unowned viewModel] state in
        switch state {
        case .initial, .loadingFinsihed:
          self?.activityIndicatorView.isHidden = true
          self?.activityIndicatorView.stopAnimating()
          self?.finishInfiniteScroll()
        case .loadingStarted:
          self?.emptyView.isHidden = true
          if !viewModel.hasData && self?.tableView.isAnimatingInfiniteScroll != true {
            self?.activityIndicatorView.isHidden = false
            self?.activityIndicatorView.startAnimating()
          }
        case .uiReloadNeeded:
          self?.tableView.reloadData()
          self?.updateInfiniteScrollView()
        case .error:
          self?.emptyView.isHidden = false
        }
      }).disposed(by: disposeBag)
  }
  
  // MARK: - Action
  
  @objc private func didTapTableView(_ sender: UIGestureRecognizer) {
    searchBar.resignFirstResponder()
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
