Pod::Spec.new do |s|
  s.name             = "Goldfish"
  s.summary          = "Something something secret ... goldfish."
  s.version          = "0.0.1"
  s.homepage         = "https://github.com/zenangst/Goldfish"
  s.license          = 'MIT'
  s.author           = { "Hyper Interaktiv AS" => "ios@hyper.no" }
  s.source           = { :git => "https://github.com/zenangst/Goldfish.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hyperoslo'

  s.osx.deployment_target = '10.11'
  s.requires_arc = true
  s.osx.source_files = 'include.h'
  s.public_header_files = 'include.h'

  s.frameworks = 'Foundation'
end
