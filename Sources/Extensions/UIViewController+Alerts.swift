//
//  UIViewController+Alerts.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import UIKit
import Rswift

// MARK: - Alerts

extension UIViewController {
  
  func showAlert(withMessage message: String,
                 showCancelButton: Bool = false,
                 okButtonTitle: String = R.string.common.ok(),
                 isOkButtonDestructive: Bool = false,
                 cancelButtonTitle: String = R.string.common.cancel(),
                 tapBlock: (() -> Void)? = nil,
                 cancelTapBlock: (() -> Void)? = nil) {
    let title = Constants.appName ?? R.string.common.appName()
    showAlert(withTitle: title,
              message: message,
              showCancelButton: showCancelButton,
              okButtonTitle: okButtonTitle,
              isOkButtonDestructive: isOkButtonDestructive,
              cancelButtonTitle: cancelButtonTitle,
              tapBlock: tapBlock,
              cancelTapBlock: cancelTapBlock)
  }
  
  func showAlert(withTitle title: String,
                 message: String,
                 showCancelButton: Bool = false,
                 okButtonTitle: String = R.string.common.ok(),
                 isOkButtonDestructive: Bool = false,
                 cancelButtonTitle: String = R.string.common.cancel(),
                 tapBlock: (() -> Void)? = nil,
                 cancelTapBlock: (() -> Void)? = nil) {
    
    let cancelButtonTitle: String? = showCancelButton ? cancelButtonTitle
      : okButtonTitle
    let otherButtonTitle: String? = showCancelButton ? okButtonTitle : nil
    
    let alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
    
    if let otherButtonTitle = otherButtonTitle {
      alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in
        cancelTapBlock?()
      }))
      let okButtonStyle: UIAlertActionStyle = isOkButtonDestructive ? .destructive : .default
      alertController.addAction(UIAlertAction(title: otherButtonTitle, style: okButtonStyle, handler: { _ in
        tapBlock?()
      }))
    } else {
      alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in
        tapBlock?()
      }))
    }
    showAlert(alertController)
  }
  
  private func showAlert(_ alertController: UIAlertController) {
    alertController.view.tintColor = .appDarkColor
    present(alertController, animated: true, completion: nil)
  }

}
