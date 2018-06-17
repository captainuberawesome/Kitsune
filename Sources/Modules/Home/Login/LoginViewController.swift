//
//  LoginViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import UIKit
import SkyFloatingLabelTextField
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
  private let emailTextField = SkyFloatingLabelTextField()
  private let passwordTextField = SkyFloatingLabelTextField()
  private let loginButton = UIButton(type: .system)
  private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
  private let viewModel: LoginViewModel
  private let disposeBag = DisposeBag()
  
  // MARK: - Init
  
  required init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    bindViewModel()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    view.backgroundColor = .white
    setupEmailTextField()
    setupPasswordTextField()
    setupLoginButton()
    setupActivityIndicator()
  }
  
  private func setupEmailTextField() {
    view.addSubview(emailTextField)
    emailTextField.autocorrectionType = .no
    emailTextField.autocapitalizationType = .none
    emailTextField.keyboardType = .emailAddress
    emailTextField.lineColor = UIColor.appPrimary.withAlphaComponent(0.7)
    emailTextField.selectedLineColor = .appPrimary
    emailTextField.placeholderColor = UIColor.appPrimary.withAlphaComponent(0.7)
    emailTextField.selectedTitleColor = .appPrimary
    emailTextField.titleColor = UIColor.appPrimary.withAlphaComponent(0.7)
    emailTextField.tintColor = .appPrimary
    emailTextField.textColor = .appDarkColor
    emailTextField.placeholder = R.string.login.emailPlaceholder()
    emailTextField.font = .textFont
    emailTextField.titleFont = .smallTextFont
    emailTextField.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(50)
      make.leading.trailing.equalToSuperview().inset(30)
    }
    
    emailTextField
      .rx.text
      .orEmpty
      .subscribe(onNext: { [unowned emailTextField] _ in
        emailTextField.errorMessage = nil
      })
      .disposed(by: disposeBag)
  }
  
  private func setupPasswordTextField() {
    view.addSubview(passwordTextField)
    passwordTextField.lineColor = UIColor.appPrimary.withAlphaComponent(0.7)
    passwordTextField.selectedLineColor = .appPrimary
    passwordTextField.placeholderColor = UIColor.appPrimary.withAlphaComponent(0.7)
    passwordTextField.selectedTitleColor = .appPrimary
    passwordTextField.titleColor = UIColor.appPrimary.withAlphaComponent(0.7)
    passwordTextField.tintColor = .appPrimary
    passwordTextField.textColor = .appDarkColor
    passwordTextField.isSecureTextEntry = true
    passwordTextField.placeholder = R.string.login.passwordPlaceholder()
    passwordTextField.font = .textFont
    passwordTextField.titleFont = .smallTextFont
    passwordTextField.snp.makeConstraints { make in
      make.top.equalTo(emailTextField.snp.bottom).offset(10)
      make.leading.trailing.equalTo(emailTextField)
    }
    
    passwordTextField
      .rx.text
      .orEmpty
      .subscribe(onNext: { [unowned passwordTextField] _ in
        passwordTextField.errorMessage = nil
      })
      .disposed(by: disposeBag)
  }
  
  private func setupLoginButton() {
    view.addSubview(loginButton)
    let height: CGFloat = 50.0
    loginButton.snp.makeConstraints { make in
      make.top.equalTo(passwordTextField.snp.bottom).offset(50)
      make.centerX.equalToSuperview()
      make.width.equalTo(150)
      make.height.equalTo(height)
    }
    loginButton.layer.cornerRadius = height * 0.5
    loginButton.backgroundColor = .appPrimary
    loginButton.tintColor = .white
    loginButton.titleLabel?.font = .titleFont
    loginButton.setTitle(R.string.login.buttonTitle(), for: .normal)
    
    loginButton.rx.tap
      .subscribe(onNext: { [unowned self] in
        self.viewModel.login(email: self.emailTextField.text, password: self.passwordTextField.text)
      }).disposed(by: disposeBag)
  }
  
  private func setupActivityIndicator() {
    view.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.center.equalTo(loginButton)
    }
    activityIndicator.isHidden = true
  }
  
  // MARK: - View Model
  
  private func bindViewModel() {
    viewModel.state
      .subscribe(onNext: { [weak self] state in
        guard let `self` = self else { return }
        if state == .loadingStarted {
          self.loginButton.setTitle("", for: .normal)
          self.loginButton.isEnabled = false
          self.activityIndicator.isHidden = false
          self.activityIndicator.startAnimating()
        } else {
          self.loginButton.setTitle(R.string.login.buttonTitle(), for: .normal)
          self.loginButton.isEnabled = true
          self.activityIndicator.stopAnimating()
          self.activityIndicator.isHidden = true
          
          if case .error(let error) = state {
            if let loginError = error as? LoginError {
              switch loginError {
              case .emptyEmail, .wrongEmailFormat, .emailTooLong:
                self.emailTextField.errorMessage = error.localizedDescription
              case .emptyPassword, .passwordTooLong:
                self.passwordTextField.errorMessage = error.localizedDescription
              }
            } else {
              self.handle(error: error)
            }
          }
        }
       })
      .disposed(by: disposeBag)
  }
}
