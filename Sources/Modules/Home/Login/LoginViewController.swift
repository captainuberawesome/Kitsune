//
//  LoginViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import UIKit

class LoginViewController: BaseViewController {
  
  private let viewModel: LoginViewModel
  
  // MARK: - Init
  
  required init(viewModel: LoginViewModel) {
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
