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
    setupPosterImageView()
    setupTitleLabel()
    setupDescriptionLabel()
  }
  
  private func setupPosterImageView() {
    contentView.addSubview(posterImageView)
    posterImageView.snp.makeConstraints { make in
      make.leading.top.equalToSuperview().offset(20)
      make.height.width.equalTo(80)
      make.bottom.lessThanOrEqualToSuperview().offset(-20)
    }
    posterImageView.contentMode = .scaleAspectFill
    posterImageView.clipsToBounds = true
  }
  
  private func setupTitleLabel() {
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(posterImageView.snp.trailing).offset(20)
      make.top.equalTo(posterImageView)
      make.trailing.equalToSuperview().offset(-20)
    }
    titleLabel.font = UIFont.boldAppFont(ofSize: 17)
    titleLabel.textColor = .appDarkColor
  }
  
  private func setupDescriptionLabel() {
    contentView.addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { make in
      make.leading.trailing.equalTo(titleLabel)
      make.top.equalTo(descriptionLabel.snp.bottom)
      make.bottom.lessThanOrEqualToSuperview().offset(-20)
    }
    descriptionLabel.font = UIFont.appFont(ofSize: 15)
    descriptionLabel.textColor = .appDarkColor
  }
  
  // MARK: - Configure
  
  func configure(viewModel: AnimeCellViewModel) {
    posterImageView.setImage(with: viewModel.smallPosterURL)
    titleLabel.text = viewModel.animeTitle
    descriptionLabel.text = viewModel.animeSynopsis
  }
}
