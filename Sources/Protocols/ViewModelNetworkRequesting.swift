//
//  ViewModelNetworkRequesting.swift
//  Kitsune
//
//  Created by Daria Novodon on 05/06/2018.
//

import Foundation
import RxSwift

enum ViewModelNetworkRequestingState {
  case initial, loadingStarted, loadingFinished
}

protocol ViewModelNetworkRequesting {
  var state: BehaviorSubject<ViewModelNetworkRequestingState> { get }
}
