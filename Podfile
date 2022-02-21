# Deployment Target
platform :ios, '13.0'

# Ignore pods code warnings
#inhibit_all_warnings!

# Add pods as frameworks so we could add obj-c and swift 3.0 pods
use_frameworks!


def core_pods
  pod 'CocoaLumberjack/Swift'
end

target 'SingleView' do
    core_pods
end


post_install do |installer|
    # Add podInstall.command and podUpdate.command shell scripts to Pods project
    pods_project = installer.pods_project
    pods_project.new_file "../Scripts/Cocoapods/podInstall.command"
    pods_project.new_file "../Scripts/Cocoapods/podUpdate.command"
    
    # Update specific target build configurations
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        # Silence deployment target warnings
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        config.build_settings.delete 'ARCHS'
      end
    end
end
