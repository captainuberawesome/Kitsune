//
//  BaseViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit

class BaseViewController: UIViewController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override var prefersStatusBarHidden: Bool {
    return false
  }
  
  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    return .slide
  }
  
  override var shouldAutorotate: Bool {
    return false
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return .portrait
  }
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNeedsStatusBarAppearanceUpdate()
  }
}
