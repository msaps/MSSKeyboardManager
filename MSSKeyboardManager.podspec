Pod::Spec.new do |s|

  s.name         = "MSSKeyboardManager"
  s.version      = "0.1.1"
  s.summary      = "Utility for managing and assisting with iOS keyboard updates."

  s.description  = <<-DESC
                    MSSKeyboardManager is a utility class that provides enhanced delegation for keyboard updates, and a keyboard dismissal component for UIView.
                   DESC

  s.homepage     = "https://github.com/MerrickSapsford/MSSKeyboardManager"
  s.license      = "MIT"
  s.author       = { "Merrick Sapsford" => "merrick@sapsford.tech" }
  s.social_media_url   = "http://twitter.com/MerrickSapsford"

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/MerrickSapsford/MSSKeyboardManager.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files  = "MSSKeyboardManager/Classes", "Source/**/*.{h,m}"
  s.frameworks = 'UIKit'

end
