
Pod::Spec.new do |s|
  s.name         = "JXPatternLock"
  s.version = "0.0.9"
  s.summary      = "一个轻量级、配置丰富、灵活扩展的图案解锁库（手势解锁库） Pattern Lock & Gesture Password"
  s.homepage     = "https://github.com/pujiaxin33/JXPatternLock"
  s.license      = "MIT"
  s.author       = { "pujiaxin33" => "317437084@qq.com" }
  s.platform     = :ios, "9.0"
  s.swift_version = "5.0"
  s.source       = { :git => "https://github.com/pujiaxin33/JXPatternLock.git", :tag => "#{s.version}" }
  s.framework    = "UIKit"
  s.source_files  = "Sources", "Sources/**/*.{swift}"
  s.requires_arc = true
end
