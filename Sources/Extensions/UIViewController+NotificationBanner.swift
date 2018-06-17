//
//  UIViewController+NotificationBanner.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/06/2018.
//

import UIKit
import NotificationBannerSwift

private extension Constants {
  static let bannerDuration: TimeInterval = 2.0
}

class CustomBannerColors: BannerColorsProtocol {
  
  internal func color(for style: BannerStyle) -> UIColor {
    switch style {
    case .danger:
      return .appSecondaryDark
    case .info:
      return .appTertiaryLight
    case .none:
      return .appTertiaryLight
    case .success:
      return .appTertiaryLight
    case .warning: 
      return .appSecondaryDark
    }
  }
  
}

extension UIViewController {
  
  func showNotificationBanner(title: String, subtitle: String? = nil, style: BannerStyle = .info) {
    let banner = NotificationBanner(title: title, subtitle: subtitle, style: style, colors: CustomBannerColors())
    banner.show()
    banner.onTap = { [weak banner] in
      banner?.dismiss()
    }
    banner.onSwipeUp = { [weak banner] in
      banner?.dismiss()
    }
    banner.duration = Constants.bannerDuration
  }
  
}
