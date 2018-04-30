//
//  NetworkErrorService.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation

private extension Constants {
  static let networkErrorsTableName = "NetworkErrors"
}

class NetworkErrorService: NSObject {

  static let networkErrorDomain = "KitsuneNetworkError"
  
  enum StatusCode: Int {
    case okStatus = 200
    case okNoContent = 204
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflict = 409
    case internalError = 500
    case badGateway = 502
  }
  
  class func error(from errorResponse: ErrorResponse) -> Error {
    let message = errorResponse.message ?? R.string.networkErrors.unknown()
    let userInfo = [NSLocalizedDescriptionKey: message]
    return NSError(domain: networkErrorDomain, code: errorResponse.code, userInfo: userInfo) as Error
  }
  
  class func offlineError() -> Error {
    let message = R.string.networkErrors.noInternet()
    let userInfo = [NSLocalizedDescriptionKey: message]
    return NSError(domain: networkErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: userInfo) as Error
  }
  
  class func unknownError() -> Error {
    let userInfo = [NSLocalizedDescriptionKey: R.string.networkErrors.unknown()]
    return NSError(domain: networkErrorDomain, code: 0, userInfo: userInfo) as Error
  }
  
  class func parseError() -> Error {
    let userInfo = [NSLocalizedDescriptionKey: R.string.networkErrors.parsing()]
    return NSError(domain: networkErrorDomain, code: 0, userInfo: userInfo) as Error
  }
}
