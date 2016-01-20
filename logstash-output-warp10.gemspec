Gem::Specification.new do |s|

  s.name            = 'logstash-output-warp10'
  s.version         = '0.0.1'
  s.licenses        = ['Apache License 2']
  s.summary         = "This output lets you output Metrics to Warp10"
  s.description     = "This gem is a logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/plugin install gemname. This gem is not a stand-alone program"
  s.authors         = ["Cityzen data"]
  s.email           = 'contact@cityzendata.net'
  s.homepage        = "https://github.com/cityzendata/logstash-output-warp10.git"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','*.gemspec','*.md','Gemfile']

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core", ">= 2.0.0.beta2", "< 3.0.0"

  s.add_runtime_dependency 'stud'
  s.add_runtime_dependency 'ftw', ['~> 0.0.40']

  s.add_development_dependency 'logstash-devutils'
  s.add_development_dependency 'logstash-input-generator'
  s.add_development_dependency 'logstash-filter-kv'
end

