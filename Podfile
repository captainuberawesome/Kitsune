inhibit_all_warnings!
use_frameworks!
workspace 'Kitsune'
platform :ios, '10.0'

def shared_pods
  pod 'SnapKit'
  pod 'SwiftLint'
  pod 'SwiftyBeaver'
  pod 'KeychainAccess'
  pod 'Alamofire'
  pod 'p2.OAuth2'
  pod 'RealmSwift'
  pod 'R.swift'
  pod 'Marshal', :git => 'https://github.com/utahiosmac/Marshal.git', :branch => 'master'
  pod 'UIScrollView-InfiniteScroll'
  pod 'Kingfisher'
  pod 'SkyFloatingLabelTextField'
  pod 'RxSwift'
  pod 'RxCocoa'
end

target 'Kitsune' do
  shared_pods
end

target 'KitsuneTests' do
  shared_pods
  pod 'Nimble'
  pod 'RxNimble'
  pod 'RxTest'
  pod 'Mockingjay'
end
