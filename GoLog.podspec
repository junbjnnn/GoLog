Pod::Spec.new do |s|
  s.name             = 'GoLog'
  s.version          = '0.0.3'
  s.summary          = 'GoLog'
  s.description      = "GoLog"
  s.homepage     = "https://github.com/junbjnnn/GoLog"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "GoLog" => "info@GoLog.com" }
  s.source           = { :git => "https://github.com/junbjnnn/GoLog.git", :tag => "#{s.version}" }

  s.ios.deployment_target = '10.0'
  s.source_files = "GoLog/**/*.{h,m,swift,xib,storyboard}"
  s.resource_bundles = {
    'GoLog' => ['GoLog/GoLogBundle/*.{storyboard,xib,xcassets,json,imageset,png}']
  }
  s.dependency 'SwiftLog', '1.0.0'
  s.swift_version = "4.2"
end
