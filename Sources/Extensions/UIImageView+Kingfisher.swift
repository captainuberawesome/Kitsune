//
//  UIImageView+Kingfisher.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import UIKit
import Kingfisher

extension UIImageView {
  func setImage(with url: URL?, placeholder: UIImage? = nil, completion: CompletionHandler? = nil) {
    kf.setImage(with: url, placeholder: placeholder, completionHandler: completion)
  }
  
  func cancelDownloadTask() {
    kf.cancelDownloadTask()
  }
}
