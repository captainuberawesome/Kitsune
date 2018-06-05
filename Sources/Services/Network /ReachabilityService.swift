//
//  ReachabilityManager.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation
import Alamofire.Swift

class ReachabilityService {
  
  private(set) var isReachable: Bool = false {
    didSet {
      listeners.forEach { listener, block in
        if listener.value != nil {
          block(isReachable)
        }
      }
    }
  }
  
  typealias ListenerBlock = (Bool) -> Void
  private typealias ListenerEntry = (listener: WeakWrapper<AnyObject>, block: ListenerBlock)
  private var listeners: [ListenerEntry] = []
  
  let networkReachabilityManager: NetworkReachabilityManager
  
  init?(host: String) {
    if let manager = NetworkReachabilityManager(host: host) {
      self.networkReachabilityManager = manager
    } else {
      return nil
    }
  }
  
  func startListening() {
    networkReachabilityManager.listener = { [unowned self] _ in
      self.isReachable = self.networkReachabilityManager.isReachable
    }
    networkReachabilityManager.startListening()
  }
  
  func stopListening() {
    networkReachabilityManager.stopListening()
    networkReachabilityManager.listener = nil
  }
  
  func add(listener: AnyObject, block: @escaping ListenerBlock) {
    remove(listener: listener)
    let wrapper = WeakWrapper(value: listener)
    let entry: ListenerEntry = (listener: wrapper, block: block)
    listeners.append(entry)
  }
  
  func remove(listener: AnyObject) {
    let filtered = listeners.filter { entry in
      let (wrapper, _) = entry
      if let value = wrapper.value {
        return value !== listener
      }
      return false      
    }
    listeners = filtered
  }
}
