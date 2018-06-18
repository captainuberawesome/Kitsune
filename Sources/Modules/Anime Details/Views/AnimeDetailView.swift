//
//  AnimeDetailView.swift
//  Kitsune
//
//  Created by Daria Novodon on 18/06/2018.
//

import UIKit

class AnimeDetailView: UIView {
  private enum InfoViewIndex: Int {
    case englishTitle = 0, japaneseTitle, type, episodeCount, status, datesAired
    static let allValues = [englishTitle, japaneseTitle, type, episodeCount, status, datesAired]
  }
  
  private let stackView = UIStackView()
  private var detailInfoViews: [AnimeDetailInfoView] = []
  
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
    setupStackView()
    setupDetailInfoViews()
  }
  
  private func setupStackView() {
    addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
  }
  
  private func setupDetailInfoViews() {
    for _ in InfoViewIndex.allValues {
      let infoView = AnimeDetailInfoView()
      stackView.addArrangedSubview(infoView)
      detailInfoViews.append(infoView)
    }
  }
  
  // MARK: Configure
  
  func configure(viewModel: AnimeDetailsViewModel) {
    for (index, infoView) in detailInfoViews.enumerated() {
      if let infoViewIndex = InfoViewIndex(rawValue: index) {
        switch infoViewIndex {
        case .englishTitle:
          infoView.configure(title: R.string.animeDetails.english(), text: viewModel.englishTitle)
        case .japaneseTitle:
          infoView.configure(title: R.string.animeDetails.japanese(), text: viewModel.japaneseTitle)
        case .type:
          infoView.configure(title: R.string.animeDetails.type(), text: viewModel.type)
        case .episodeCount:
          infoView.configure(title: R.string.animeDetails.episodes(), text: viewModel.episodeCount)
        case .status:
          infoView.configure(title: R.string.animeDetails.status(), text: viewModel.status)
        case .datesAired:
          infoView.configure(title: R.string.animeDetails.aired(), text: viewModel.airDates)
        }
      }
    }
  }
}
