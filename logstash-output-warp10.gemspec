Gem::Specification.new do |s|
  s.name            = 'logstash-output-warp10'
  s.version         = '0.1.0'
  s.licenses        = ['Apache-2.0']
  s.summary         = 'This output lets you output Metrics to Warp10'
  s.description     = 'This gem is a logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/logstash-plugin install gemname. This gem is not a stand-alone program'
  s.authors         = ['Cityzen Data']
  s.email           = 'contact@cityzendata.net'
  s.homepage        = 'https://github.com/cityzendata/logstash-output-warp10.git'
  s.require_paths   = ['lib']

  # Files
  s.files = Dir['lib/**/*', 'spec/**/*', 'vendor/**/*', '*.gemspec', '*.md', 'CONTRIBUTORS', 'Gemfile', 'LICENSE', 'NOTICE.TXT']
  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { 'logstash_plugin' => 'true', 'logstash_group' => 'output' }

  # Gem dependencies
  s.add_runtime_dependency 'ftw', '~> 0.0.48'
  s.add_runtime_dependency 'logstash-codec-plain'
  s.add_runtime_dependency 'stud', '~> 0.0.23'

  s.add_development_dependency 'logstash-devutils'
  s.add_development_dependency 'rspec', '~> 3.7', '>= 3.7'
end
