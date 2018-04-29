//
//  NetworkManager.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Alamofire.Swift
import Foundation

struct PaginationKeys {
  static let limit = "limit"
  static let offset = "offset"
}

private extension Constants {
  static let requestTimeout: TimeInterval = 10
}

class NetworkManager: NSObject {

  struct HeaderKeys {
    static let authorization = "Authorization"
    static let token = "token"
  }
  
  private let userDataStore: UserDataStore
  private let manager: Alamofire.SessionManager
  private let logger = RequestLogger()
  
  // MARK: - Init
  
  required init(userDataStore: UserDataStore = UserDataStore()) {
    self.userDataStore = userDataStore
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = Constants.requestTimeout
    manager = Alamofire.SessionManager(configuration: configuration)
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
  
  @discardableResult
  func baseAuthorizationRequest(method: HTTPMethod,
                                url: String,
                                parameters: [String: Any],
                                encoding: ParameterEncoding = JSONEncoding.default,
                                headers: [String: String] = [:],
                                completion: @escaping (Response<EmptyResponse>) -> Void) -> Request {
    
    let completionForBaseRequest: (URLRequest?, HTTPURLResponse?, Response<EmptyResponse>) -> Void
    
    completionForBaseRequest = { (_, response, result) in
      if let token = response?.allHeaderFields[HeaderKeys.token] as? String, !token.isEmpty {
        self.userDataStore.token = token
      }
      completion(result)
    }
    
    return baseRequest(manager: manager,
                       method: method,
                       url: url,
                       parameters: parameters,
                       completion: completionForBaseRequest)
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
