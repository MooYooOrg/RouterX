Pod::Spec.new do |s|
  s.name = 'RouterX'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'A Ruby on Rails flavored URI routing library.'
  s.homepage = 'https://github.com/jasl/RouterX'
  s.authors = {'jasl' => 'jasl9187@hotmail.com'}
  s.source = {:git => 'https://github.com/MooYooOrg/RouterX.git', :tag => s.version}

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'

  s.source_files = %w(Sources/*.swift)
end
