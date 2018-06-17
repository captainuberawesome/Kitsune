//
//  AnimeDetailsViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/06/2018.
//

import UIKit
import RxSwift
import RxCocoa

class AnimeDetailsViewController: BaseViewController {
  private let viewModel: AnimeDetailsViewModel
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  
  private(set) var onDidDeinit = PublishSubject<Void>()
  
  // MARK: - Init
  
  required init(viewModel: AnimeDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Deinit
  
  deinit {
    onDidDeinit.onNext(())
  }
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    view.backgroundColor = .white
  }
}
