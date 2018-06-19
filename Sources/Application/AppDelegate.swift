//
//  AppDelegate.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: - Properties
  
  private lazy var appDependency = AppDependency.default
  private lazy var mainCoordinator: MainCoordinator = self.getMainCoordinator()
  var window: UIWindow?
  
  // MARK: - App Life Cycle

  func application(_ application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    if NSClassFromString("XCTestCase") != nil {
      return true
    }
    startMainCoordinator()
    return true
  }
  
  // MARK: - Private Methods
  
  private func getMainCoordinator() -> MainCoordinator {
    let windowFrame = UIScreen.main.bounds
    let window = UIWindow(frame: windowFrame)
    self.window = window
    return MainCoordinator(window: window, appDependency: appDependency)
  }
  
  private func startMainCoordinator() {
    mainCoordinator.start()
  }
}
