Pod::Spec.new do |s|
  s.name         = "CropView"
  s.version      = "0.1.0"
  s.platform     = :ios, '9.0'
  s.summary      = "Crop rectangle view like in Notes App"
  s.homepage     = "https://github.com/rzmn/CropView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "nikitarazumnuy" => "agerfirelol@gmail.com" }
  s.source       = { :git => "https://github.com/rzmn/CropView.git", :tag => s.version.to_s}
  s.source_files = "Pod/Classes/*.swift"
  s.requires_arc = true
end
