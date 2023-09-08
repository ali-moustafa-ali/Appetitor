platform :ios, '11.0'
inhibit_all_warnings!

target 'Dietness' do
use_frameworks!
source 'https://github.com/CocoaPods/Specs.git'

  # Comment the next line if you don't want to use dynamic frameworks

pod 'JVFloatLabeledTextField'
pod 'SDWebImage'
pod 'ScrollableSegmentedControl'
pod 'Closures'
pod 'IQKeyboardManagerSwift'
pod 'lottie-ios'
pod 'Alamofire'
pod 'MOLH'
pod 'Kingfisher'
pod 'StepIndicator'
pod 'iOSDropDown'
pod 'FSCalendar'
#pod 'goSellSDK'
pod 'OTPInputView'
pod 'SideMenu'
pod 'PusherSwift'
pod 'Firebase'
pod 'Firebase/Messaging'
pod 'OTPFieldView'
pod 'MyFatoorah'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end

end
