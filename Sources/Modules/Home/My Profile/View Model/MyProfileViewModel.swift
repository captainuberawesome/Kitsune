//
//  MyProfileViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 17/05/2018.
//

import Foundation
import RxSwift
import RxCocoa

private extension Constants {
  static let defaultPaginationLimit = 10
}

class MyProfileViewModel: ViewModelNetworkRequesting {
  
  typealias Dependencies = HasLoginStateService & HasUserService & HasReachabilityService

  private(set) var cellViewModels = BehaviorRelay<[ProfileCellViewModel]>(value: [])
  private let dependencies: Dependencies
  private var user: User?
  private let disposeBag = DisposeBag()
  let onUserUpdated = PublishSubject<Void>()
  let state = BehaviorSubject<ViewModelNetworkRequestingState>(value: .initial)
  
  var isLoggedIn: Bool {
    return dependencies.loginStateService.isLoggedIn
  }

  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    cellViewModels.accept(createViewModels())
    subscribeToReachability()
  }
  
  // MARK: - Public
  
  func loadCachedData() {
    user = dependencies.userService.savedActiveUser()
    onUserUpdated.onNext(())
    cellViewModels.accept(createViewModels(withUser: user))
  }
  
  func reloadData() {
    state.onNext(.loadingStarted)
    dependencies.userService.myProfile()
      .subscribe(onNext: { userResponse in
        self.state.onNext(.loadingFinished)
        if let user = userResponse.user {
          self.user = user
          self.onUserUpdated.onNext(())
          self.cellViewModels.accept(self.createViewModels(withUser: user))
          self.dependencies.userService.saveActiveUserId(user.id)
          self.dependencies.userService.save(user: user)
        }
      }, onError: { error in
        self.state.onNext(.loadingFinished)
        self.state.onNext(.error(error))
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: ProfileCellViewModel
  
  private func createViewModels(withUser user: User? = nil) -> [ProfileCellViewModel] {
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
    birthdayDateFormatter.dateFormat = "MMMM"
    var birthdayString: String? = nil
    if let date = user?.birthday {
      birthdayString = birthdayDateFormatter.string(from: date) + " " + (date.dayWithOrdinalSuffix ?? "")
    } else if user != nil {
      birthdayString = R.string.profile.defaultValue()
    }
    let birthdayViewModel = ProfileCellViewModel(infoType: .birthday, value: birthdayString, cellReuseIdentifier: reuseIdentifier)
    
    let joinDateFormatter = DateFormatter()
    joinDateFormatter.locale = Constants.appLocale
    joinDateFormatter.dateFormat = "MMMM"
    var joinDateString: String? = nil
    if let date = user?.joinDate {
      joinDateString = joinDateFormatter.string(from: date) + " " + (date.dayWithOrdinalSuffix ?? "") + ", "
      joinDateFormatter.dateFormat = "yyyy"
      joinDateString?.append(joinDateFormatter.string(from: date))
    } else if user != nil {
      joinDateString = R.string.profile.defaultValue()
    }
    let joinDateViewModel = ProfileCellViewModel(infoType: .joinDate, value: joinDateString, cellReuseIdentifier: reuseIdentifier)
    
    return [genderViewModel, locationViewModel, birthdayViewModel, joinDateViewModel]
  }
  
  // MARK: - Reachability
  
  private func subscribeToReachability() {
    dependencies.reachabilityService?.isReachable
      .skip(1)
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] isReachable in
          if isReachable && self?.user == nil && (try? self?.state.value())
            != ViewModelNetworkRequestingState.initial {
            self?.reloadData()
          }
        })
      .disposed(by: disposeBag)
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
