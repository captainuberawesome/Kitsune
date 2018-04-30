//
//  HomeViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import UIKit

class AnimeListViewController: BaseViewController {
  
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
  
  // MARK: - Deinit
  
  deinit {
    
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
    
  }
  
  // MARK: - View Model
  
  private func bindViewModel() {
    
  }
}
