//
//  NetworkManager.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation
import Alamofire
import p2_OAuth2

struct PaginationKeys {
  static let limit = "limit"
  static let offset = "offset"
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

class NetworkManager: NSObject {

  struct HeaderKeys {
    static let authorization = "Authorization"
    static let token = "token"
  }
  
  private let oauth: OAuth2PasswordGrant
  private let userDataStore: UserDataStore
  private let manager: Alamofire.SessionManager
  private let logger = RequestLogger()
  
  // MARK: - Init
  
  required init(userDataStore: UserDataStore = UserDataStore()) {
    self.userDataStore = userDataStore
    oauth = OAuth2PasswordGrant(settings: [OAuth2ParameterKeys.clientId: Credentials.appClientID,
                                           OAuth2ParameterKeys.clientSecret: Credentials.appClientSecret,
                                           OAuth2ParameterKeys.authorizeURI: URLFactory.Auth.oauth,
                                           OAuth2ParameterKeys.tokenURI: URLFactory.Auth.accessToken,
                                           OAuth2ParameterKeys.keychain: false] as OAuth2JSON)
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = Constants.requestTimeout
    manager = Alamofire.SessionManager(configuration: configuration)
    let retrier = OAuth2RetryHandler(oauth2: oauth)
    manager.adapter = retrier
    manager.retrier = retrier
    super.init()
  }
  
  // MARK: - Requests
  
  @discardableResult
  func baseRequest<T>(method: HTTPMethod,
                      url: String,
                      parameters: Parameters? = nil,
                      encoding: ParameterEncoding = JSONEncoding.default,
                      headers: [String: String] = [:],
                      completion: @escaping (Response<T>) -> Void) -> Request {
    
    return baseRequest(manager: manager,
                       method: method,
                       url: url,
                       parameters: parameters,
                       encoding: encoding,
                       headers: headers) { (_, _, result: Response<T>) in
                        DispatchQueue.main.async {
                          completion(result)
                        }
    }
  }
  
  @discardableResult
  func baseRequest<T>(manager: Alamofire.SessionManager,
                      method: HTTPMethod,
                      url: String,
                      parameters: Parameters? = nil,
                      encoding: ParameterEncoding = JSONEncoding.default,
                      headers: [String: String] = [:],
                      completion: @escaping (Response<T>) -> Void) -> Request {
    
    return baseRequest(manager: manager,
                       method: method,
                       url: url,
                       parameters: parameters,
                       encoding: encoding,
                       headers: headers) { (_, _, result: Response<T>) in
                        DispatchQueue.main.async {
                          completion(result)
                        }
    }
  }
  
  @discardableResult
  func baseRequest<T>(manager: Alamofire.SessionManager,
                      method: HTTPMethod,
                      url: String,
                      parameters: Parameters? = nil,
                      encoding: ParameterEncoding = JSONEncoding.default,
                      headers: [String: String] = [:],
                      completion: @escaping ((URLRequest?, HTTPURLResponse?, Response<T>) -> Void)) -> Request {
    
    var headers = headers
    if let token = userDataStore.token {
      headers[HeaderKeys.authorization] = token
    }
    
    let request = manager.request(url,
                                  method: method,
                                  parameters: parameters,
                                  encoding: encoding,
                                  headers: headers).responseJSON { response in
                                    
      self.logger.logDataResponse(response)
      
      switch response.result {
        
      case .success(let value):
        
        var valueObject = value as? [String: AnyHashable]
        if T.self == EmptyResponse.self && valueObject == nil {
          valueObject = [:]
        }
        
        if let code = response.response?.statusCode, let valueObject = valueObject {
          do {
            let jsonData = try JSONSerialization.data(withJSONObject: valueObject, options: .prettyPrinted)
            self.handleBaseRequestSuccessResponse(response: response.response,
                                                  request: response.request,
                                                  jsonData: jsonData,
                                                  statusCode: code,
                                                  completion: completion)
          } catch let error {
            DispatchQueue.main.async {
              completion(response.request, response.response, .failure(error as NSError))
            }
          }
        } else {
          DispatchQueue.main.async {
            completion(response.request, response.response, .failure(NetworkErrorManager.unknownError()))
          }
        }
        
      case.failure(let error):
        DispatchQueue.main.async {
          completion(response.request, response.response, .failure(error as NSError))
        }
      }
                                    
    }
    
    logger.logRequest(request.request)
    return request
  }
  
  func baseAuthorizationRequest(username: String, password: String,
                                completion: @escaping (Response<EmptyResponse>) -> Void) {
    oauth.username = username
    oauth.password = password
    oauth.authorize { authParameters, error in
      if authParameters != nil {
        completion(Response.success(EmptyResponse()))
      } else {
        completion(Response.failure(error as NSError?))
      }
    }
  }

  // MARK: - Response Handler
  
  private func handleBaseRequestSuccessResponse<T>(response: HTTPURLResponse?,
                                                   request: URLRequest?,
                                                   jsonData: Data,
                                                   statusCode code: Int,
                                                   completion: @escaping ((URLRequest?, HTTPURLResponse?, Response<T>) -> Void)) {
    let statusCode = NetworkErrorManager.StatusCode(rawValue: code) ?? NetworkErrorManager.StatusCode.internalError
    switch statusCode {
    case .okStatus, .okNoContent:
      DispatchQueue.main.async {
        let decoder = JSONDecoder()
        if let object = try? decoder.decode(T.self, from: jsonData) {
          completion(request, response, .success(object))
        } else {
          completion(request, response, .failure(NetworkErrorManager.parseError()))
        }
      }
    default:
      handleBaseErrorResponse(response: response, request: request, jsonData: jsonData, completion: completion)
    }
  }
  
  private func handleBaseErrorResponse<T>(response: HTTPURLResponse?,
                                          request: URLRequest?,
                                          jsonData: Data,
                                          completion: @escaping ((URLRequest?, HTTPURLResponse?, Response<T>) -> Void)) {
    let decoder = JSONDecoder()
    if let errorResponse = try? decoder.decode(ErrorResponse.self, from: jsonData) {
      let networkError = NetworkErrorManager.error(from: errorResponse)
      DispatchQueue.main.async {
        completion(request, response, .failure(networkError))
      }
    } else {
      DispatchQueue.main.async {
        completion(request, response, .failure(NetworkErrorManager.unknownError()))
      }
    }
  }

}
