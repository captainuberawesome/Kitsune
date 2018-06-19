//
//  AnimeListErrorView.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/06/2018.
//

import UIKit
import RxSwift

class AnimeListErrorView: UIView {
  private let containerView = UIView()
  private let imageView = UIImageView(image: R.image.warning())
  private let warningLabel = UILabel()
  private let reloadButton = UIButton(type: .system)
  
  lazy var buttonPress: Observable = {
    return reloadButton.rx.tap.asObservable()
  }()
  
  // MARK: Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
    
  private func setup() {
    setupContainerView()
    setupImageView()
    setupWarningLabel()
    setupReloadButton()
  }
  
  private func setupContainerView() {
    addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.leading.greaterThanOrEqualToSuperview().offset(30)
      make.trailing.lessThanOrEqualToSuperview().offset(-30)
    }
  }
  
  private func setupImageView() {
    containerView.addSubview(imageView)
    imageView.contentMode = .center
    imageView.snp.makeConstraints { make in
      make.top.centerX.equalToSuperview()
    }
  }
  
  private func setupWarningLabel() {
    containerView.addSubview(warningLabel)
    warningLabel.font = UIFont.largeTitleFont
    warningLabel.textColor = .appDarkColor
    warningLabel.textAlignment = .center
    warningLabel.numberOfLines = 0
    warningLabel.text = R.string.animeList.couldNotLoad()
    containerView.addSubview(warningLabel)
    warningLabel.snp.makeConstraints { make in
      make.centerX.leading.trailing.equalToSuperview()
      make.top.equalTo(imageView.snp.bottom).offset(10)
    }
  }
  
  private func setupReloadButton() {
    containerView.addSubview(reloadButton)
    let height: CGFloat = 50.0
    reloadButton.snp.makeConstraints { make in
      make.top.equalTo(warningLabel.snp.bottom).offset(20)
      make.centerX.equalToSuperview()
      make.width.equalTo(150)
      make.height.equalTo(height)
      make.bottom.equalToSuperview()
    }
    reloadButton.layer.cornerRadius = height * 0.5
    reloadButton.backgroundColor = .appPrimary
    reloadButton.tintColor = .white
    reloadButton.titleLabel?.font = .titleFont
    reloadButton.setTitle(R.string.animeList.retry(), for: .normal)
  }
    
}
