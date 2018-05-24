//
//  MyProfileViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import Foundation

private extension Constants {
  static let defaultPaginationLimit = 10
}

class MyProfileViewModel {
  
  typealias Dependencies = HasLoginStateService & HasMyProfileService
    & HasUserDataService & HasRealmService
  private(set) var cellViewModels: [ProfileCellViewModel] = []
  private let dependencies: Dependencies
  private var user: User?
  let dataSource = ProfileDataSource()
  
  var isLoggedIn: Bool {
    return dependencies.loginStateService.isLoggedIn
  }
  
  var onErrorEncountered: ((Error?) -> Void)?
  var onLoadingStarted: (() -> Void)?
  var onLoadingFinished: (() -> Void)?
  var onUIReloadRequested: (() -> Void)?

  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    cellViewModels = createViewModels()
  }
  
  // MARK: - Public
  
  func loadCachedData() {
    guard let activeUserId = dependencies.userDataService.activeUserId else { return }
    user = dependencies.realmService.user(withId: activeUserId)
    cellViewModels = createViewModels(withUser: user)
    dataSource.updateData(with: self)
    onUIReloadRequested?()
  }
  
  func reloadData() {
    onLoadingStarted?()
    dependencies.myProfileService.myProfile { response in
      self.onLoadingFinished?()
      switch response {
      case .success(let result):
        if let user = result.user {
          self.user = user
          self.cellViewModels = self.createViewModels(withUser: user)
          self.dataSource.updateData(with: self)
          self.dependencies.userDataService.activeUserId = user.id
          self.dependencies.realmService.save(object: user)
        }
        DispatchQueue.main.async {
          self.onUIReloadRequested?()
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self.onErrorEncountered?(error)
        }
      }
    }
  }
  
  // MARK: ProfileCellViewModel
  
  func createViewModels(withUser user: User? = nil) -> [ProfileCellViewModel] {
    let reuseIdentifier = ProfileCell.reuseIdentifier
    
    var userGender = user?.gender.capitalized
    if user != nil && userGender?.isEmpty != false {
      userGender = R.string.profile.defaultValue()
    }
    let genderViewModel  = ProfileCellViewModel(infoType: .gender, value: userGender, cellReuseIdentifier: reuseIdentifier)
    
    var userLocation = user?.location.capitalized
    if user != nil && userLocation?.isEmpty != false {
      userLocation = R.string.profile.defaultValue()
    }
    let locationViewModel = ProfileCellViewModel(infoType: .location, value: userLocation, cellReuseIdentifier: reuseIdentifier)
    
    let birthdayDateFormatter = DateFormatter()
    birthdayDateFormatter.locale = Constants.appLocale
    birthdayDateFormatter.dateFormat = "MMMM dd"
    var birthdayString: String? = nil
    if let date = user?.birthday {
      birthdayString = birthdayDateFormatter.string(from: date) + date.daySuffix
    } else if user != nil {
      birthdayString = R.string.profile.defaultValue()
    }
    let birthdayViewModel = ProfileCellViewModel(infoType: .birthday, value: birthdayString, cellReuseIdentifier: reuseIdentifier)
    
    let joinDateFormatter = DateFormatter()
    joinDateFormatter.locale = Constants.appLocale
    joinDateFormatter.dateFormat = "MMMM dd"
    var joinDateString: String? = nil
    if let date = user?.joinDate {
      joinDateString = joinDateFormatter.string(from: date) + date.daySuffix + ", "
      joinDateFormatter.dateFormat = "yyyy"
      joinDateString?.append(joinDateFormatter.string(from: date))
    } else if user != nil {
      joinDateString = R.string.profile.defaultValue()
    }
    let joinDateViewModel = ProfileCellViewModel(infoType: .joinDate, value: joinDateString, cellReuseIdentifier: reuseIdentifier)
    
    return [genderViewModel, locationViewModel, birthdayViewModel, joinDateViewModel]
  }
  
}

extension MyProfileViewModel: ProfileHeaderViewModelProtocol {
  var coverImage: URL? {
    guard let coverImageURLString = user?.coverImage else { return nil }
    return URL(string: coverImageURLString)
  }
  
  var avatar: URL? {
    guard let avatarURLString = user?.avatar else { return nil }
    return URL(string: avatarURLString)
  }
  
  var name: String? {
    return user?.name
  }
}
