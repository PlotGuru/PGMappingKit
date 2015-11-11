Pod::Spec.new do |s|
  s.name             = 'PGMappingKit'
  s.version          = '1.0'
  s.license          = 'MIT'
  s.summary          = 'Lightweight JSON Synchronization to Core Data'
  s.homepage         = 'https://github.com/PlotGuru/PGMappingKit'
  s.social_media_url = 'https://twitter.com/PlotGuru'
  s.author           = { "Justin Jia" => "justin.jia@plotguru.com" }
  s.source           = { :git => "https://github.com/PlotGuru/PGMappingKit.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'PGMappingKit/*.{h,m}'
  s.frameworks = 'Foundation'
  s.dependency 'AFNetworking', '~> 2.3'
end
