$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'navitia_api/version'

Gem::Specification.new do |s|
  s.name        = 'navitia_api'
  s.licenses    = ['MIT']
  s.version     = NavitiaApi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Paul Bonaud']
  s.email       = ['paul+gh@bonaud.fr']
  s.homepage    = 'http://github.com/paulrbr/navitia_api'
  s.summary     = %q(Easily access the API of NAVITIA.)
  s.description = %q(Easily use Ruby or the command line to find information from the NAVITIA API.)

  s.rubyforge_project = 'navitia_api'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'hashie'
  s.add_dependency 'faraday'
  s.add_dependency 'sawyer'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'multi_json'
  s.add_development_dependency 'gokdok'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'coveralls'
end
