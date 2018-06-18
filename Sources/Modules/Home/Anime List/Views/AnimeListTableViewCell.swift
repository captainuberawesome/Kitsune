//
//  AnimeListTableViewCell.swift
//  Kitsune
//
//  Created by Daria Novodon on 30/04/2018.
//

import UIKit

class AnimeListTableViewCell: UITableViewCell {
  private let posterImageView = UIImageView()
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let backgroundContentView = UIView()
  private let disclosureIndicatorImageView = UIImageView()
  
  // MARK: - Init
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  // MARK: - Prepare For Reuse
  
  override func prepareForReuse() {
    posterImageView.cancelDownloadTask()
    titleLabel.text = nil
    descriptionLabel.text = nil
  }
  
  // MARK: - Setup
  
  private func setup() {
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    contentView.addSubview(backgroundContentView)
    backgroundContentView.backgroundColor = .white
    backgroundContentView.layer.cornerRadius = 10
    backgroundContentView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(10)
      make.top.bottom.equalToSuperview().inset(5)
    }
    setupPosterImageView()
    setupTitleLabel()
    setupDescriptionLabel()
    setupDisclosureIndicatorImageView()
  }
  
  private func setupPosterImageView() {
    backgroundContentView.addSubview(posterImageView)
    posterImageView.snp.makeConstraints { make in
      make.leading.top.equalToSuperview().offset(10)
      make.height.width.equalTo(80)
      make.bottom.lessThanOrEqualToSuperview().offset(-10)
    }
    posterImageView.contentMode = .scaleAspectFill
    posterImageView.clipsToBounds = true
  }
  
  private func setupTitleLabel() {
    backgroundContentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(posterImageView.snp.trailing).offset(10)
      make.top.equalTo(posterImageView).offset(-5)
    }
    titleLabel.numberOfLines = 0
    titleLabel.lineBreakMode = .byWordWrapping
    titleLabel.font = .titleFont
    titleLabel.textColor = .appDarkColor
  }
  
  private func setupDescriptionLabel() {
    backgroundContentView.addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { make in
      make.leading.trailing.equalTo(titleLabel)
      make.top.equalTo(titleLabel.snp.bottom)
      make.bottom.lessThanOrEqualToSuperview().offset(-10)
      make.height.lessThanOrEqualTo(100)
    }
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = .byTruncatingTail
    descriptionLabel.font = .textFont
    descriptionLabel.textColor = .appDarkColor
  }
  
  private func setupDisclosureIndicatorImageView() {
    disclosureIndicatorImageView.image = R.image.disclosureIndicator()?.withRenderingMode(.alwaysTemplate)
    disclosureIndicatorImageView.tintColor = .appDarkColor
    disclosureIndicatorImageView.contentMode = .center
    backgroundContentView.addSubview(disclosureIndicatorImageView)
    disclosureIndicatorImageView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-10)
      make.centerY.equalToSuperview()
      make.height.width.equalTo(30)
      make.leading.equalTo(titleLabel.snp.trailing).offset(10)
    }
  }
  
  // MARK: - Configure
  
  func configure(viewModel: AnimeCellViewModel) {
    posterImageView.setImage(with: viewModel.smallPosterURL)
    titleLabel.text = viewModel.animeTitle
    descriptionLabel.text = viewModel.animeSynopsis
  }
}
