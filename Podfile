platform :ios, '13.0'
inhibit_all_warnings!
install! 'cocoapods', :warn_for_unused_master_specs_repo => false
use_frameworks! :linkage => :static

target 'SingleView' do
end

post_install do |installer|
  # Add podInstall.command and podUpdate.command shell scripts to Pods project
  pods_project = installer.pods_project
  pods_project.new_file "../Scripts/Cocoapods/podInstall.command"
  pods_project.new_file "../Scripts/Cocoapods/podUpdate.command"
end
