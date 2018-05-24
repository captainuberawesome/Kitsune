//
//  AvatarView.swift
//  Kitsune
//
//  Created by Daria Novodon on 24/05/2018.
//

import Foundation
import Kingfisher
import SnapKit

struct BorderStyle {
  let width: CGFloat
  let color: UIColor
  
  static let noBorder = BorderStyle(width: 0, color: .clear)
}

extension CALayer {
  func apply(borderStyle: BorderStyle) {
    borderColor = borderStyle.color.cgColor
    borderWidth = borderStyle.width
  }
}

class AvatarView: UIView {
  private let imageView = UIImageView()
  private let imageViewBackground = UIView()
  
  var borderStyle: BorderStyle = .noBorder {
    didSet {
      imageViewBackground.layer.apply(borderStyle: borderStyle)
    }
  }
  
  var imageBackgroundColor: UIColor? {
    get {
      return imageView.backgroundColor
    }
    set {
      imageView.backgroundColor = newValue
    }
  }
  
  var image: UIImage? {
    get {
      return imageView.image
    }
    set {
      imageView.image = newValue
    }
  }
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let radius = imageViewBackground.frame.width * 0.5
    imageViewBackground.layer.cornerRadius = radius
    // workaround to fix color bleeding from cropped view's edges
    let path = UIBezierPath(arcCenter: imageViewBackground.center,
                            radius: imageViewBackground.frame.width * 0.5 - borderStyle.width,
                            startAngle: 0,
                            endAngle: 2 * CGFloat.pi,
                            clockwise: true)
    path.close()
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    imageView.layer.masksToBounds = true
    imageView.layer.mask = shapeLayer
  }
  
  // MARK: - Methods
  
  func reset() {
    imageView.image = nil
  }
  
  func cancelDownloadTask() {
    imageView.cancelDownloadTask()
  }
  
  // MARK: - Private Methods
  
  private func setup() {
    backgroundColor = .clear
    
    addSubview(imageViewBackground)
    imageViewBackground.backgroundColor = .clear
    imageViewBackground.clipsToBounds = true
    imageViewBackground.layer.borderColor = UIColor.white.cgColor
    imageViewBackground.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.height.equalToSuperview()
    }
    
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageViewBackground.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.height.equalToSuperview()
    }
  }
  
  func setAvatarWithURL(_ url: URL?, placeholder: UIImage? = nil, completion: CompletionHandler? = nil) {
    imageView.setImage(with: url, placeholder: placeholder, completion: completion)
  }
}
