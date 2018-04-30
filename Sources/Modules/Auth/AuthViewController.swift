//
//  AuthViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit

class AuthViewController: BaseViewController {
  
  private let loginTextField = UITextField()
  private let passwordTextField = UITextField()
  private let textFieldsContainerView = UIView()
  private let loginButton = UIButton(type: .system)
  private let viewModel: AuthViewModel
  
  // MARK: - Init
  
  required init(viewModel: AuthViewModel) {
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
  }
  
  // MARK: - Setup
  
  private func setup() {
    view.backgroundColor = .white
    setupLoginButton()
    view.addSubview(textFieldsContainerView)
    textFieldsContainerView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(20)
    }
    setupLoginTextField()
    setupPasswordTextField()
  }
  
  private func setupLoginButton() {
    view.addSubview(loginButton)
    loginButton.setTitle("Login", for: .normal)
    loginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
    loginButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(50)
      make.centerX.equalToSuperview()
    }
  }
  
  private func setupLoginTextField() {
    textFieldsContainerView.addSubview(loginTextField)
    loginTextField.borderStyle = .roundedRect
    loginTextField.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
    }
  }
  
  private func setupPasswordTextField() {
    textFieldsContainerView.addSubview(passwordTextField)
    passwordTextField.borderStyle = .roundedRect
    passwordTextField.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(loginTextField.snp.bottom).offset(10)
    }
  }
  
  // MARK: - View Model
  
  private func bindViewModel() {
    
  }
  
  // MARK: - Actions
  
  @objc private func didTapLoginButton(_ sender: UIButton) {
    viewModel.login(username: loginTextField.text, password: passwordTextField.text)
  }
}
