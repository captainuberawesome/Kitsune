//
//  ReachabilityManager.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation
import Alamofire.Swift
import RxSwift
import RxCocoa

protocol ReachabilityProtocol {
  var isReachable: BehaviorSubject<Bool> { get }
  func startListening()
  func stopListening()
}

class ReachabilityService: ReachabilityProtocol {
  
  let isReachable = BehaviorSubject<Bool>(value: true)
  
  private let networkReachabilityManager: NetworkReachabilityManager
  
  init?(host: String) {
    if let manager = NetworkReachabilityManager(host: host) {
      self.networkReachabilityManager = manager
    } else {
      return nil
    }
  }
  
  func startListening() {
    networkReachabilityManager.listener = { [unowned self] _ in
      self.isReachable.onNext(self.networkReachabilityManager.isReachable)
    }
    networkReachabilityManager.startListening()
  }
  
  func stopListening() {
    networkReachabilityManager.stopListening()
    networkReachabilityManager.listener = nil
  }
}
