//
//  LoginViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import Foundation
import RxSwift

enum LoginError: Error {
  case emptyEmail, emptyPassword, wrongEmailFormat, emailTooLong, passwordTooLong
}

extension LoginError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .emptyEmail:
      return R.string.login.errorValidationEmptyEmail()
    case .emptyPassword:
      return R.string.login.errorValidationEmptyPassword()
    case .wrongEmailFormat:
      return R.string.login.errorValidationEmailFormat()
    case .emailTooLong:
      return R.string.login.errorValidationEmailTooLong(Constants.emailPasswordMaxCharacterCount)
    case .passwordTooLong:
      return R.string.login.errorValidationPasswordTooLong(Constants.emailPasswordMaxCharacterCount)
    }
  }
}

private extension Constants {
  static let emailPasswordMaxCharacterCount = 120
}

class LoginViewModel: ViewModelNetworkRequesting {
  
  typealias Dependencies = HasAuthService
  
  private let dependencies: Dependencies
  private let disposeBag = DisposeBag()
  let state = BehaviorSubject<ViewModelNetworkRequestingState>(value: .initial)
  private(set) var onDidFinishLogin = PublishSubject<Void>()
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Validateion
  
  private func validate(email: String?) throws {
    guard let email = email, !email.isEmpty else {
      throw LoginError.emptyEmail
    }
    if email.count > Constants.emailPasswordMaxCharacterCount {
      throw LoginError.emailTooLong
    }
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    if !email.matches(regularExpression: emailRegex) {
      throw LoginError.wrongEmailFormat
    }
  }
  
  private func validate(password: String?) throws {
    guard let password = password, !password.isEmpty else {
      throw LoginError.emptyPassword
    }
    if password.count > Constants.emailPasswordMaxCharacterCount {
      throw LoginError.passwordTooLong
    }
  }
  
  // MARK: - Public
  
  func login(email: String?, password: String?) {
    do {
      try validate(email: email)
      try validate(password: password)
      guard let email = email, let password = password else { return }
      state.onNext(.loadingStarted)
      dependencies.authService.authorize(username: email, password: password)
        .subscribe(onNext: { _ in
          self.state.onNext(.loadingFinished)
          self.onDidFinishLogin.onNext(())
        }, onError: { error in
          self.state.onNext(.error(error))
        })
        .disposed(by: disposeBag)
    } catch let error {
      state.onNext(.error(error))
    }
  }
}
