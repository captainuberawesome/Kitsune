//
//  AnimeListEmptyView.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/06/2018.
//

import UIKit

class AnimeListEmptyView: UIView {
  private let containerView = UIView()
  private let imageView = UIImageView(image: R.image.searchIcon()?.withRenderingMode(.alwaysTemplate))
  private let emptyLabel = UILabel()
  
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
    setupEmptyLabel()
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
    imageView.tintColor = .appDarkColor
    imageView.snp.makeConstraints { make in
      make.top.centerX.equalToSuperview()
    }
  }
  
  private func setupEmptyLabel() {
    containerView.addSubview(emptyLabel)
    emptyLabel.font = UIFont.largeTitleFont
    emptyLabel.textColor = .appDarkColor
    emptyLabel.textAlignment = .center
    emptyLabel.numberOfLines = 0
    emptyLabel.text = R.string.animeList.emptyResults()
    containerView.addSubview(emptyLabel)
    emptyLabel.snp.makeConstraints { make in
      make.centerX.leading.trailing.equalToSuperview()
      make.top.equalTo(imageView.snp.bottom).offset(10)
      make.bottom.equalToSuperview()
    }
  }
}
