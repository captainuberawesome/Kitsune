//
//  ProfileHeaderView.swift
//  Kitsune
//
//  Created by Daria Novodon on 24/05/2018.
//

import UIKit

protocol ProfileHeaderViewModelProtocol {
  var coverImage: URL? { get }
  var avatar: URL? { get }
  var name: String? { get }
}

class ProfileHeaderView: UIView {
  private let coverImageView = UIImageView()
  private let avatarView = AvatarView()
  private let nameLabel = UILabel()
  
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
    setupCoverImageView()
    setupAvatarImageView()
    setupNameLabel()
  }
  
  private func setupCoverImageView() {
    addSubview(coverImageView)
    coverImageView.contentMode = .scaleAspectFill
    coverImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    coverImageView.image = R.image.coverPlaceholder()
    coverImageView.clipsToBounds = true
    let darkenView = UIView()
    darkenView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    coverImageView.addSubview(darkenView )
    darkenView .snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupAvatarImageView() {
    addSubview(avatarView)
    avatarView.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-20)
      make.leading.equalToSuperview().offset(20)
      make.height.width.equalTo(80)
    }
    avatarView.image = R.image.avatarPlaceholder()
    avatarView.borderStyle = .init(width: 2, color: .white)
  }
  
  private func setupNameLabel() {
    addSubview(nameLabel)
    nameLabel.font = UIFont.boldAppFont(ofSize: 18)
    nameLabel.textColor = .white
    nameLabel.snp.makeConstraints { make in
      make.leading.equalTo(avatarView.snp.trailing).offset(10)
      make.centerY.equalTo(avatarView)
      make.trailing.lessThanOrEqualToSuperview().offset(-20)
    }
  }
  
  // MARK: - Configure
  
  func configure(viewModel: ProfileHeaderViewModelProtocol) {
    coverImageView.setImage(with: viewModel.coverImage, placeholder: R.image.coverPlaceholder())
    avatarView.setAvatarWithURL(viewModel.avatar, placeholder: R.image.avatarPlaceholder())
    nameLabel.text = viewModel.name
  }
}
