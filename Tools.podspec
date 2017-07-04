Pod::Spec.new do |s|
  s.name = 'Tools'
  s.version = '0.3.0'
  s.license = 'MIT'
  s.summary = 'Some ios development tools'
  s.homepage = 'https://github.com/OlegKetrar/Tools'
  s.authors = { 'OlegKetrar' => 'oleg.ketrar.dev@yandex.com' }
  s.source = { :git => 'https://github.com/OlegKetrar/Tools.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Sources/*.swift'
end
