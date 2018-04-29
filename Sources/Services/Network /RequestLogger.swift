//
//  RequestLogger.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation
import Alamofire

class RequestLogger {
  
  func logRequest(_ request: URLRequest?) {
    logDivider()
    
    if let method = request?.httpMethod, let url = request?.url?.absoluteString {
     log.debug("Request:\t\(method) \(url)")
    }
    if let headers = request?.allHTTPHeaderFields {
      logDictionary(title: "Headers", dictionary: headers)
    }
    if let data = request?.httpBody {
      logData(data: data)
    }
    
    logDivider()
  }
  
  func logDataResponse(_ dataResponse: DataResponse<Any>?) {
    let request = dataResponse?.request
    let response = dataResponse?.response
    
    logDivider()
    
    if let method = request?.httpMethod, let url = request?.url?.absoluteString {
      log.debug("Response:\t\(method) \(url)")
    }
    if let code = response?.statusCode {
      log.debug("Code: \t\(code)")
    }
    if let headers = response?.allHeaderFields {
      logDictionary(title: "Headers", dictionary: headers)
    }
    if let data = dataResponse?.data {
      logData(data: data)
    }
    
    logDivider()
  }
  
  private func logDivider() {
    log.debug("\n---------------------\n")
  }
  
  private func logDictionary(title: String, dictionary: [AnyHashable: Any]) {
    log.debug("\(title):\t[")
    for (key, value) in dictionary {
      log.debug("\t\(key) : \(value)")
    }
    log.debug("]")
  }

  private func logData(data: Data) {
    do {
      let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
      let pretty = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
      
      if let string = NSString(data: pretty, encoding: String.Encoding.utf8.rawValue) {
        log.debug("JSON:\t\(string)")
      }
    } catch {
      if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
        log.debug("Data:\t\(string)")
      }
    }
  }
  
  private func jsonString(from data: Data) -> String? {
    guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
      let pretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
        return nil
    }
    
    return NSString(data: pretty, encoding: String.Encoding.utf8.rawValue) as String?
  }
  
}
