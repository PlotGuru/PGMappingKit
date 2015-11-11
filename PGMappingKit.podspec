Pod::Spec.new do |s|
  s.name             = "PGMappingKit"
  s.version          = "1.0"
  s.summary          = "A lightweight JSON to Core Data synchronization framework."
  s.homepage         = "https://github.com/PlotGuru/PGMappingKit"
  s.license          = 'MIT'
  s.author           = { "Justin Jia" => "justin.jia@plotguru.com" }
  s.source           = { :git => "https://github.com/PlotGuru/PGMappingKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/PlotGuru'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'PGMappingKit/*'
  s.public_header_files = 'PGMappingKit/PGMappingKit.h'
  s.frameworks = 'Foundation'
  s.dependency 'AFNetworking', '~> 2.3'
end
