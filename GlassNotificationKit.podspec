Pod::Spec.new do |s|
  s.name         = 'GlassNotificationKit'
  s.version      = '1.0'
  s.license      = 'MIT'
  s.summary      = 'An iOS framework for mirroring app notices to glass'
  s.homepage     = 'https://github.com/ericlewis/GlassNotificationKit'
  s.author       = 'Eric Lewis'
  s.source       = { :git => 'git://github.com/ericlewis/GlassNotificationKit.git'}
  s.source_files = 'GlassNotificationKit/*'
  s.requires_arc = true
  s.dependency 'Google-API-Client'
end