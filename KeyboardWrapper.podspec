
Pod::Spec.new do |s|
  s.name             = "KeyboardWrapper"
  s.version          = "0.1.0"
  s.summary          = "A wrapper for UIKeyboard notifications."

  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/zummenix/KeyboardWrapper"
  s.license          = 'MIT'
  s.author           = { "Aleksey Kuznetsov" => "zummenix@gmail.com" }
  s.source           = { :git => "https://github.com/zummenix/KeyboardWrapper.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.frameworks = 'UIKit'
end
