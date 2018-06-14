//
//  ProfileViewModelTestss.swift
//  KitsuneTests
//
//  Created by Daria Novodon on 13/06/2018.
//

import XCTest
import Nimble
import RxNimble
import RxSwift

@testable import Kitsune

class ProfileViewModelTests: XCTestCase {
  let dependency = DependencyMock()
  let failingDependency = DependencyFailureMock()
  let disposeBag = DisposeBag()
  
  override func tearDown() {
    dependency.userDataService.clearData()
    dependency.realmService.clear()
  }
  
  func testLoadCachedData() {
    let viewModel = MyProfileViewModel(dependencies: dependency)
    
    expect(viewModel.isLoggedIn) == true
    let activeUserId = randomString
    dependency.userDataService.activeUserId = activeUserId
    let user = createUser(id: activeUserId)
    
    var createdCellViewModels = false
    var comparedEmptyViewModels = false
    viewModel.cellViewModels
      .subscribe(onNext: { cellViewModels in
        if !comparedEmptyViewModels {
          self.compareEmptyViewModels(cellViewModels)
          comparedEmptyViewModels = true
          return
        }
        createdCellViewModels = true
        self.compareCellViewModels(cellViewModels, toUserValues: user)
      }, onError: { error in
        expect(error).to(beNil())
      })
      .disposed(by: disposeBag)
    
    waitUntil { done in
      self.dependency.realmService.save(object: user) {
        viewModel.loadCachedData()
        expect(viewModel.avatar) == URL(string: user.avatar)
        expect(viewModel.coverImage) == URL(string: user.coverImage)
        expect(viewModel.name) == user.name
        expect(createdCellViewModels) == true
        expect(comparedEmptyViewModels) == true
        done()
      }
    }
  }
  
  func testReloadData() {
    let viewModel = MyProfileViewModel(dependencies: dependency)
    
    expect(viewModel.isLoggedIn) == true
    
    var mockState: ViewModelNetworkRequestingState = .initial
    viewModel.state
      .subscribe(onNext: { state in
        expect(state) == mockState
        if mockState == .initial {
          mockState = .loadingStarted
        } else {
          mockState = .loadingFinished
        }
      }, onError: { error in
        expect(error).to(beNil())
      })
      .disposed(by: disposeBag)

    var createdCellViewModels = false
    var comparedEmptyViewModels = false
    viewModel.cellViewModels
      .subscribe(onNext: { cellViewModels in
        if !comparedEmptyViewModels {
          self.compareEmptyViewModels(cellViewModels)
          comparedEmptyViewModels = true
          return
        }
        createdCellViewModels = true
        self.compareCellViewModels(cellViewModels, toUserValues: Constants.responseUser)
      }, onError: { error in
        expect(error).to(beNil())
      })
      .disposed(by: disposeBag)
    
    viewModel.reloadData()
    expect(mockState) == .loadingFinished
    expect(viewModel.avatar) == URL(string: Constants.responseUser.avatar)
    expect(viewModel.coverImage) == URL(string: Constants.responseUser.coverImage)
    expect(viewModel.name) == Constants.responseUser.name
    expect(createdCellViewModels) == true
    expect(comparedEmptyViewModels) == true
  }
  
  func testReloadDataFail() {
    let viewModel = MyProfileViewModel(dependencies: failingDependency)
    
    expect(viewModel.isLoggedIn) == false
    
    var mockState: ViewModelNetworkRequestingState = .initial
    viewModel.state
      .subscribe(onNext: { state in
        expect(state) == mockState
        if mockState == .initial {
          mockState = .loadingStarted
        } else {
          mockState = .loadingFinished
        }
      }, onError: { error in
        expect(error.localizedDescription) == Constants.dependencyMockError.localizedDescription
      })
      .disposed(by: disposeBag)
    
    var comparedEmptyViewModels = false
    
    viewModel.cellViewModels
      .subscribe(onNext: { cellViewModels in
        self.compareEmptyViewModels(cellViewModels)
        comparedEmptyViewModels = true
      }, onError: { error in
        expect(error).to(beNil())
      })
      .disposed(by: disposeBag)
    
    viewModel.reloadData()
    expect(mockState) == .loadingFinished
    expect(viewModel.avatar).to(beNil())
    expect(viewModel.coverImage).to(beNil())
    expect(viewModel.name).to(beNil())
    expect(comparedEmptyViewModels) == true
  }

  // MARK: - Helper functions
  
  private func compareEmptyViewModels(_ viewModels: [ProfileCellViewModel]) {
    let reuseIdentifier = ProfileCell.reuseIdentifier
    let genderViewModel  = ProfileCellViewModel(infoType: .gender, value: nil, cellReuseIdentifier: reuseIdentifier)
    let locationViewModel = ProfileCellViewModel(infoType: .location, value: nil, cellReuseIdentifier: reuseIdentifier)
    let birthdayViewModel = ProfileCellViewModel(infoType: .birthday, value: nil, cellReuseIdentifier: reuseIdentifier)
    let joinDateViewModel = ProfileCellViewModel(infoType: .joinDate, value: nil, cellReuseIdentifier: reuseIdentifier)
    
    for (index, viewModel) in viewModels.enumerated() {
      switch index {
      case 0:
        expect(viewModel) == genderViewModel
      case 1:
        expect(viewModel) == locationViewModel
      case 2:
        expect(viewModel) == birthdayViewModel
      case 3:
        expect(viewModel) == joinDateViewModel
      default:
        break
      }
    }
  }
  
  private func compareCellViewModels(_ viewModels: [ProfileCellViewModel], toUserValues user: User) {
    let reuseIdentifier = ProfileCell.reuseIdentifier
    let genderViewModel  = ProfileCellViewModel(infoType: .gender, value: user.gender.capitalized,
                                                cellReuseIdentifier: reuseIdentifier)
    
    let locationViewModel = ProfileCellViewModel(infoType: .location, value: user.location.capitalized,
                                                 cellReuseIdentifier: reuseIdentifier)
    let birthdayDateFormatter = DateFormatter()
    birthdayDateFormatter.locale = Constants.appLocale
    birthdayDateFormatter.dateFormat = "MMMM dd"
    let birthdayString: String? = birthdayDateFormatter.string(from: user.birthday!) + user.birthday!.daySuffix
    let birthdayViewModel = ProfileCellViewModel(infoType: .birthday, value: birthdayString, cellReuseIdentifier: reuseIdentifier)
    
    let joinDateFormatter = DateFormatter()
    joinDateFormatter.locale = Constants.appLocale
    joinDateFormatter.dateFormat = "MMMM dd"
    var joinDateString = joinDateFormatter.string(from: user.joinDate!) + user.joinDate!.daySuffix + ", "
    joinDateFormatter.dateFormat = "yyyy"
    joinDateString.append(joinDateFormatter.string(from: user.joinDate!))
    let joinDateViewModel = ProfileCellViewModel(infoType: .joinDate, value: joinDateString, cellReuseIdentifier: reuseIdentifier)
    
    for (index, viewModel) in viewModels.enumerated() {
      switch index {
      case 0:
        expect(viewModel) == genderViewModel
      case 1:
        expect(viewModel) == locationViewModel
      case 2:
        expect(viewModel) == birthdayViewModel
      case 3:
        expect(viewModel) == joinDateViewModel
      default:
        break
      }
    }
  }
}