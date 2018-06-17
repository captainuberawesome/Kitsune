//
//  ViewModelNetworkRequesting.swift
//  Kitsune
//
//  Created by Daria Novodon on 05/06/2018.
//

import Foundation
import RxSwift

enum ViewModelNetworkRequestingState: Equatable {
  case initial, loadingStarted, loadingFinished, error(Error)
  
  static func == (lhs: ViewModelNetworkRequestingState, rhs: ViewModelNetworkRequestingState) -> Bool {
    switch (lhs, rhs) {
    case (.error(let error1), .error(let error2)):
      return error1.localizedDescription == error2.localizedDescription
    case (.initial, .initial):
      return true
    case (.loadingStarted, .loadingStarted):
      return true
    case (.loadingFinished, .loadingFinished):
      return true
    default:
      return false
    }
  }
  
  static func != (lhs: ViewModelNetworkRequestingState?, rhs: ViewModelNetworkRequestingState) -> Bool {
    guard let lhs = lhs else { return false }
    return !(lhs == rhs)
  }
}

protocol ViewModelNetworkRequesting {
  var state: BehaviorSubject<ViewModelNetworkRequestingState> { get }
}
