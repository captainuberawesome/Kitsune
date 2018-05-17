//
//  MyLibraryViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import UIKit

class MyLibraryViewController: BaseViewController {
  
  private let viewModel: MyLibraryViewModel
  
  // MARK: - Init
  
  required init(viewModel: MyLibraryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    bindViewModel()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Model
  
  private func bindViewModel() {
    
  }
}
