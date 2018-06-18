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
  private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
  private let tableView = UITableView(frame: .zero, style: .plain)
  private let searchBar = UISearchBar()
  private let errorView = AnimeListErrorView()
  private let emptyView = AnimeListEmptyView()
  private var infiniteScrollAdded = false
  private let viewModel: AnimeListViewModel
  private let dataSource = AnimeListDataSource()
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
    view.backgroundColor = .appPrimary
    setupSearchBar()
    setupTableView()
    view.addSubview(activityIndicatorView)
    activityIndicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    setupErrorView()
    setupEmptyView()
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
    
    searchBar.rx.searchButtonClicked
      .subscribe(onNext: { [unowned self] in
        if self.searchBar.text?.isEmpty != false {
          self.viewModel.mode = .default
          self.tableView.reloadData()
        }
        self.searchBar.resignFirstResponder()
      }).disposed(by: disposeBag)
  }
  
  private func setupTableView() {
    dataSource.configure(withTableView: tableView, viewModel: viewModel)
    view.addSubview(tableView)
    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(searchBar.snp.bottom)
    }
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    tableView.register(AnimeListTableViewCell.self, forCellReuseIdentifier: AnimeListTableViewCell.reuseIdentifier)
    let tap = UITapGestureRecognizer()
    tap.cancelsTouchesInView = false
    tap
      .rx.event
      .bind(onNext: { [unowned self] _ in
        self.searchBar.resignFirstResponder()
      })
      .disposed(by: disposeBag)
    tableView.addGestureRecognizer(tap)
  }
  
  private func setupErrorView() {
    view.addSubview(errorView)
    errorView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(searchBar.snp.bottom)
    }
    errorView.backgroundColor = .white
    errorView.isHidden = true
    errorView.buttonPress
      .subscribe(onNext: { [unowned self] in
          self.viewModel.reloadData()
        })
      .disposed(by: disposeBag)
  }
  
  private func setupEmptyView() {
    view.addSubview(emptyView)
    emptyView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(searchBar.snp.bottom)
    }
    emptyView.backgroundColor = .white
    emptyView.isHidden = true
  }
  
  // MARK: - View Model
  
  private func bindViewModel() {
    viewModel.state
      .subscribe(onNext: { [weak self, unowned viewModel] state in
          self?.emptyView.isHidden = true
          switch state {
          case .initial, .loadingFinished:
            self?.activityIndicatorView.isHidden = true
            self?.activityIndicatorView.stopAnimating()
            self?.finishInfiniteScroll()
            if state == .loadingFinished && !viewModel.hasData {
              self?.emptyView.isHidden = false
            }
          case .loadingStarted:
            self?.errorView.isHidden = true
            if !viewModel.hasData && self?.tableView.isAnimatingInfiniteScroll != true {
              self?.activityIndicatorView.isHidden = false
              self?.activityIndicatorView.startAnimating()
            }
          case .error(let error):
            self?.handle(error: error)
            self?.errorView.isHidden = false
          }
        })
      .disposed(by: disposeBag)
    viewModel.canLoadMorePagesSubject
      .skip(1)
      .subscribe(onNext: { [weak self] canLoadMorePages in
        if canLoadMorePages {
          self?.addInfiniteScroll()
        } else {
          self?.removeInfiniteScroll()
        }
      })
      .disposed(by: disposeBag)
  }
}

// MARK: Infinite scroll

extension AnimeListViewController {
  private func addInfiniteScroll() {
    if infiniteScrollAdded {
      return
    }
    tableView.infiniteScrollIndicatorStyle = .white
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
}
