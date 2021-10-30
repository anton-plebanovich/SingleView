
######

use_frameworks! :linkage => :static

######

#use_frameworks!
#install! 'cocoapods', :deduplicate_targets => false

######

#use_frameworks! :linkage => :static
#install! 'cocoapods', :deduplicate_targets => true

######

platform :ios, '12.0'
inhibit_all_warnings!

target 'SingleView' do
  pod 'AppUtils/Main', :path => 'LocalPod/AppUtils.podspec', :inhibit_warnings => false
end

target 'SingleViewExtension' do
  pod 'AppUtils/Extension', :path => 'LocalPod/AppUtils.podspec', :inhibit_warnings => false
end


post_install do |installer|
  pods_project = installer.pods_project
  
  # Add podInstall.command and podUpdate.command shell scripts to Pods project
  podspec = pods_project.new_file "../LocalPod/AppUtils.podspec"
  podspec.explicit_file_type = 'text.script.ruby'
  
  pods_project.new_file "../Scripts/Cocoapods/podInstall.command"
  pods_project.new_file "../Scripts/Cocoapods/podUpdate.command"
end
