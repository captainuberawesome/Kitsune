//
//  AnimeDetailInfoView.swift
//  Kitsune
//
//  Created by Daria Novodon on 18/06/2018.
//

import UIKit

class AnimeDetailInfoView: UIView {
  private let titleLabel = UILabel()
  private let textLabel = UILabel()
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
    setupTitleLabel()
    setupTextLabel()
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }
    titleLabel.font = UIFont.titleFont
    titleLabel.textColor = UIColor.appDarkColor
  }
  
  private func setupTextLabel() {
    addSubview(textLabel)
    textLabel.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom)
    }
    textLabel.font = UIFont.textFont
    textLabel.textColor = UIColor.appDarkColor
    textLabel.numberOfLines = 0
  }
  
  // MARK: Configure
  
  func configure(title: String?, text: String?) {
    titleLabel.text = title
    textLabel.text = text
  }
}
