#
# AppUtils.podspec
#

# https://guides.cocoapods.org/syntax/podspec.html

Pod::Spec.new do |s|
  s.name             = 'AppUtils'
  s.version          = '1.0.0'
  s.summary          = 'App utils layer'
  s.description      = <<-DESC
  Separated from the main target App utils layer.
                       DESC

  s.homepage         = 'https://github.com/anton-plebanovich/SingleView'
  s.author           = { 'Anton Plebanovich' => 'anton.plebanovich@gmail.com' }
  s.source           = { :path => '.' }

  s.ios.deployment_target = '12.0'
  s.swift_versions = ['5.1']
  s.frameworks = 'Foundation'

  s.subspec 'Extension' do |subspec|
      subspec.source_files = 'Core/**/*.swift', 'Extension/**/*.swift'
  end

  s.subspec 'Main' do |subspec|
      subspec.source_files = 'Core/**/*.swift', 'Main/**/*.swift'
  end
end
