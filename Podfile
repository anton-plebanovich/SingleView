# Deployment Target
platform :ios, '13.0'

# Ignore pods code warnings
#inhibit_all_warnings!

# Add pods as frameworks so we could add obj-c and swift 3.0 pods
use_frameworks!

install! 'cocoapods', :warn_for_unused_master_specs_repo => false

def core_pods
  pod 'BMXCall', '~> 2.3.1'
  pod 'BMXCore', '~> 2.3.1'
  
  # Works fine if I leave only dependencies. 'OAuthSwift' is updated to '2.2.0' though
  #  pod 'Alamofire'
  #  pod 'Japx/Alamofire'
  #  pod 'Japx/Core'
  #  pod 'OAuthSwift'
  #  pod 'TwilioVideo'
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
  
  installer.pods_project.targets.each do |target|
    
    if ['BMXCall', 'BMXCore', 'Alamofire', 'Japx', 'OAuthSwift', 'TwilioVideo'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        if config.name.include?("Release")
          config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64 x86_64 i386'
        end
      end
    end
    
    target.build_configurations.each do |config|
      config.build_settings['LD_NO_PIE'] = 'NO'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings.delete('ARCHS')
      config.build_settings.delete('IPHONEOS_DEPLOYMENT_TARGET')
    end
    
  end # each target
end # installer
