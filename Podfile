# Deployment Target
platform :ios, '13.0'

# Ignore pods code warnings
#inhibit_all_warnings!

# Add pods as frameworks so we could add obj-c and swift 3.0 pods
use_frameworks!

install! 'cocoapods', :warn_for_unused_master_specs_repo => false

def core_pods
#  pod 'KeychainAccess'
#  pod 'Alamofire'
#  pod 'ActionPickerUtils', :git => 'https://github.com/APUtils/ActionPickerUtils'
#  pod 'APExtensions', :git => 'https://github.com/APUtils/APExtensions'
#  pod 'BaseClasses', :git => 'https://github.com/APUtils/BaseClasses'
#  pod 'RxUtils', :git => 'https://github.com/APUtils/RxUtils'
#  pod 'KeyboardAvoidingView'
#  pod 'SwiftReorder', :git => 'https://github.com/anton-plebanovich/SwiftReorder'
#  pod 'RealmSwift', :git => 'https://github.com/realm/realm-cocoa', :tag => 'v10.14.0'
#  pod 'RxSwift'
#  pod 'RxCocoa'
#  pod 'RxRelay'
#  pod 'LogsManager', :git => 'https://github.com/APUtils/LogsManager'
#  pod 'SDWebImage', :git => 'https://github.com/dreampiggy/SDWebImage', :branch => 'fix_race_condition_cancel_callback'
#  pod 'Moya', :git => 'https://github.com/anton-plebanovich/Moya', :branch => 'master'
#  pod 'Moya/RxSwift', :git => 'https://github.com/anton-plebanovich/Moya', :branch => 'master'
  pod 'lottie-ios'
end

target 'SingleView' do
    core_pods
end


post_install do |installer|
    # Add podInstall.command and podUpdate.command shell scripts to Pods project
    pods_project = installer.pods_project
    pods_project.new_file "../Scripts/Cocoapods/podInstall.command"
    pods_project.new_file "../Scripts/Cocoapods/podUpdate.command"
    
    # Silence Pods project warning
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['DEAD_CODE_STRIPPING'] = 'YES'
    end
    
    # Update specific target build configurations
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        # Silence deployment target warnings
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        config.build_settings.delete 'ARCHS'
      end
    end
end
