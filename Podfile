# Deployment Target
platform :ios, '10.3'

# Ignore pods code warnings
inhibit_all_warnings!

# Add pods as frameworks so we could add obj-c and swift 3.0 pods
use_frameworks!


def core_pods
  pod 'KeychainAccess'
#    pod 'Alamofire'
#    pod 'ActionPickerUtils', :git => 'https://github.com/APUtils/ActionPickerUtils'
#    pod 'APExtensions', :git => 'https://github.com/APUtils/APExtensions'
#    pod 'BaseClasses', :git => 'https://github.com/APUtils/BaseClasses'
#    pod 'RxUtils', :git => 'https://github.com/APUtils/RxUtils'
#    pod 'KeyboardAvoidingView'
#    pod 'SwiftReorder', :git => 'https://github.com/anton-plebanovich/SwiftReorder'
#    pod 'RealmSwift', '~> 4.0'
#    pod 'RxSwift'
#    pod 'RxCocoa'
#  pod 'LogsManager', :git => 'https://github.com/APUtils/LogsManager'
#  pod 'SDWebImage', :git => 'https://github.com/dreampiggy/SDWebImage', :branch => 'fix_race_condition_cancel_callback'
end

target 'SingleView' do
    core_pods
end


post_install do |installer|
    # Add podInstall.command and podUpdate.command shell scripts to Pods project
    pods_project = installer.pods_project
    pods_project.new_file "../podInstall.command"
    pods_project.new_file "../podUpdate.command"
end
