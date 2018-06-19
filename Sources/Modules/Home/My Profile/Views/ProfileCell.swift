//
//  ProfileCell.swift
//  Kitsune
//
//  Created by Daria Novodon on 24/05/2018.
//

import UIKit

class ProfileCell: UITableViewCell {
  
  private let iconImageView = UIImageView()
  private let titleLabel = UILabel()
  private let valueLabel = UILabel()
  
  // MARK: - Init
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupIconImageView()
    setupTitleLabel()
    setupValueLabel()
  }
  
  private func setupIconImageView() {
    contentView.addSubview(iconImageView)
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.clipsToBounds = true
    iconImageView.tintColor = .appPrimary
    iconImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.top.bottom.equalToSuperview().inset(10)
      make.height.width.equalTo(30)
    }
  }
  
  private func setupTitleLabel() {
    contentView.addSubview(titleLabel)
    titleLabel.font = UIFont.titleFont
    titleLabel.textColor = UIColor.appDarkColor
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(iconImageView.snp.trailing).offset(10)
      make.centerY.equalToSuperview()
    }
  }
  
  private func setupValueLabel() {
    contentView.addSubview(valueLabel)
    valueLabel.font = UIFont.textFont
    valueLabel.textColor = UIColor.appDarkColor
    valueLabel.snp.makeConstraints { make in
      make.leading.equalTo(titleLabel.snp.trailing).offset(20)
      make.centerY.equalToSuperview()
      make.trailing.lessThanOrEqualToSuperview().offset(-20)
    }
  }
  
  // MARK: - Configure
  
  func configure(withIcon icon: UIImage?, title: String?, value: String?) {
    iconImageView.image = icon
    titleLabel.text = title?.appending(":")
    valueLabel.text = value
  }
}
