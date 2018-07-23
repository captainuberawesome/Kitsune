//
//  NetworkService.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation
import Alamofire
import Marshal
import p2_OAuth2
import RxSwift
import RxCocoa

struct PaginationKeys {
  static let limit = "page[limit]"
  static let offset = "page[offset]"
}

private extension Constants {
  static let requestTimeout: TimeInterval = 10
  static let oauthResponseType = "password"
}

private struct OAuth2ParameterKeys {
  static let clientId = "client_id"
  static let clientSecret = "client_secret"
  static let authorizeURI = "authorize_uri"
  static let tokenURI = "token_uri"
  static let keychain = "keychain"
}

class NetworkService: NSObject, LoginStateNetworkProtocol {

  struct HeaderKeys {
    static let authorization = "Authorization"
    static let token = "token"
  }
  
  private let oauth: OAuth2PasswordGrant
  private let manager: Alamofire.SessionManager
  private let logger = RequestLogger()
  
  var isLoggedIn: Bool {
    return oauth.accessToken != nil
  }
  
  // MARK: - Init
  
  required init(useKeychain: Bool = true) {
    oauth = OAuth2PasswordGrant(settings: [OAuth2ParameterKeys.clientId: Credentials.appClientID,
                                           OAuth2ParameterKeys.clientSecret: Credentials.appClientSecret,
                                           OAuth2ParameterKeys.authorizeURI: URLFactory.Auth.oauth,
                                           OAuth2ParameterKeys.tokenURI: URLFactory.Auth.accessToken,
                                           OAuth2ParameterKeys.keychain: useKeychain] as OAuth2JSON)
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = Constants.requestTimeout
    manager = Alamofire.SessionManager(configuration: configuration)
    let retrier = OAuth2RetryHandler(oauth2: oauth)
    manager.adapter = retrier
    manager.retrier = retrier
    super.init()
  }
  
  // MARK: - Requests
  
  func baseRequest<T: Unmarshaling>(method: HTTPMethod,
                                    url: String,
                                    parameters: Parameters? = nil,
                                    encoding: ParameterEncoding = JSONEncoding.default,
                                    headers: [String: String] = [:]) -> Observable<T> {
    let observableObject = Observable<T>.create { observer -> Disposable in
      let request = self.manager.request(url,
                                         method: method,
                                         parameters: parameters,
                                         encoding: encoding,
                                         headers: headers).responseJSON { response in
        self.logger.logDataResponse(response)
        switch response.result {
        case .success(let value):
          var marshaledObject = value as? MarshaledObject
          if T.self == EmptyResponse.self && marshaledObject == nil {
            marshaledObject = [:]
          }
          if let code = response.response?.statusCode, let marshaledObject = marshaledObject {
            let statusCode = NetworkErrorService.StatusCode(rawValue: code) ?? NetworkErrorService.StatusCode.internalError
            switch statusCode {
            case .okStatus, .createdStatus, .okNoContent:
              if let object = try? T(object: marshaledObject) {
                observer.onNext(object)
                observer.onCompleted()
              } else {
                observer.onError(NetworkErrorService.parseError())
              }
            default:
              if let errorResponse = try? ErrorResponse(object: marshaledObject) {
                let networkError = NetworkErrorService.error(from: errorResponse)
                observer.onError(networkError)
              } else {
                observer.onError(NetworkErrorService.unknownError())
              }
            }
          } else {
            observer.onError(NetworkErrorService.unknownError())
          }
        case.failure(let error):
          observer.onError(error)
        }
      }
      self.logger.logRequest(request.request)
      return Disposables.create {
        request.cancel()
      }
    }
    return observableObject
  }
  
  func baseAuthorizationRequest(username: String, password: String) -> Observable<EmptyResponse> {
    let observableObject = Observable<EmptyResponse>.create { observer -> Disposable in
      self.oauth.username = username
      self.oauth.password = password
      self.oauth.authorize { _, error in
        if let error = error {
          //workaround for OAuth2Error not having appropriate localizedDescription
          let userInfo = [NSLocalizedDescriptionKey: error.description]
          let authError = NSError(domain: Constants.errorDomain, code: 1, userInfo: userInfo)
          observer.onError(authError as Error)
        } else {
          observer.onNext(EmptyResponse(object: [:]))
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
    return observableObject
  }
  
  func baseSignOutRequest() -> Observable<EmptyResponse> {
    let observableObject = Observable<EmptyResponse>.create { observer -> Disposable in
      self.oauth.forgetTokens()
      observer.onNext(EmptyResponse(object: [:]))
      observer.onCompleted()
      return Disposables.create()
    }
    return observableObject
  }
}
