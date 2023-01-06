Pod::Spec.new do |spec|

  spec.name         = "LogosUtils"
  spec.version      = "0.1.0"
  spec.summary      = "A personal Swift library used for Mac and iOS development."

  spec.description  = <<-DESC
                    This is my personal Swift utility library. There are many like it, but this one is mine.
                   DESC
  spec.homepage     = "https://reformert.no"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Tom-Roger Mittag" => "mittaaku@protonmail.com" }
  spec.ios.deployment_target = "9.0"
  spec.osx.deployment_target = "10.9"
  spec.source       = { :git => "https://github.com/Mittaaku/LogosUtils.git", :tag => "#{spec.version}" }
  spec.source_files  = "LogosUtils", "LogosUtils/**/*.{swift}"
  spec.exclude_files = "LogosUtils/Exclude"
  spec.swift_version = "5.0"
end
