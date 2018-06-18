//
//  AnimeDetailsViewController.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/06/2018.
//

import UIKit
import RxSwift
import RxCocoa

class AnimeDetailsViewController: BaseViewController {
  private let viewModel: AnimeDetailsViewModel
  
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let posterImageView = UIImageView()
  private let detailView = AnimeDetailView()
  private let textView = UITextView()
  
  private(set) var onDidDeinit = PublishSubject<Void>()
  
  // MARK: - Init
  
  required init(viewModel: AnimeDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Deinit
  
  deinit {
    onDidDeinit.onNext(())
  }
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    configure(viewModel: viewModel)
  }
  
  // MARK: - Setup
  
  private func setup() {
    view.addSubview(scrollView)
    view.backgroundColor = .appPrimary
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    scrollView.addSubview(contentView)
    contentView.backgroundColor = .white
    contentView.layer.cornerRadius = 10
    contentView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(10)
      make.width.equalTo(view).offset(-20)
    }
    
    setupPosterImageView()
    setupDetailView()
    setupTextView()
  }
  
  private func setupPosterImageView() {
    contentView.addSubview(posterImageView)
    posterImageView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-10)
      make.width.equalToSuperview().multipliedBy(0.3)
      make.height.equalTo(posterImageView.snp.width).multipliedBy(1.42)
    }
    posterImageView.contentMode = .scaleAspectFit
  }
  
  private func setupDetailView() {
    contentView.addSubview(detailView)
    detailView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(10)
      make.top.equalToSuperview().inset(8)
      make.centerY.equalTo(posterImageView)
      make.trailing.equalTo(posterImageView.snp.leading).offset(-8)
    }
  }
  
  private func setupTextView() {
    contentView.addSubview(textView)
    textView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(10)
      make.top.equalTo(detailView.snp.bottom).offset(15)
      make.bottom.equalToSuperview().offset(-10)
    }
    textView.isScrollEnabled = false
    textView.isSelectable = false
    textView.isEditable = false
    textView.textContainerInset = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)
    textView.font = UIFont.appFont(ofSize: 17)
    textView.textColor = .appDarkColor
  }
  
  // MARK: - Configure
  
  func configure(viewModel: AnimeDetailsViewModel) {
    posterImageView.setImage(with: viewModel.posterImageURL)
    detailView.configure(viewModel: viewModel)
    textView.text = viewModel.synopsis
  }
}
