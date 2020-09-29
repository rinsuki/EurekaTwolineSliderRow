Pod::Spec.new do |s|
  s.name             = 'EurekaTwolineSliderRow'
  s.version          = '0.1.0'
  s.summary          = 'old-style SliderRow is back!'
  s.description      = <<-DESC
old-style SliderRow is back!

TwolineSliderRow is a restoration of an earlier SliderRow design.

since slider is placed on a different line from the title, slider length will not change even if title gets longer due to localization or other.
                       DESC

  s.homepage         = 'https://github.com/rinsuki/EurekaTwolineSliderRow'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'xmartlabs', 'rinsuki'
  s.source           = { :git => 'https://github.com/rinsuki/EurekaTwolineSliderRow.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/428rinsuki'

  s.ios.deployment_target = '11.0'

  s.source_files = 'EurekaTwolineSliderRow/Classes/**/*'
  s.swift_version = '5.0'
  
  s.frameworks = 'UIKit'
  s.dependency "Eureka", "~> 5.3.0"
end
