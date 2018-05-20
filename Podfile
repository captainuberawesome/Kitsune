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
end

target 'Kitsune' do
  shared_pods
end

target 'KitsuneTests' do
    shared_pods
    pod 'Nimble'
    pod 'Mockingjay'
    pod 'SwiftyJSON'
end
