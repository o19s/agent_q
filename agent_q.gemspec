Gem::Specification.new do |s|
  s.name        = 'agent_q'
  s.version     = '0.0.13'
  s.date        = '2020-12-01'
  s.summary     = "Headless agent for test driven relevancy with Quepid.com"
  s.description = "A ruby agent that wraps a head browser that runs a specific Quepid Case and returns if your relevancy score meets or falls below a threshold."
  s.authors     = ["Eric Pugh"]
  s.email       = ['epugh@opensourceconnections.com']
  s.files       = ["lib/agent_q.rb"]
  s.executables = ["agent_q"]
  s.homepage    = 'http://rubygems.org/gems/agent_q'
  s.license     = 'MIT'

  s.add_runtime_dependency "capybara", '~> 3.31', '>= 3.31'
  s.add_runtime_dependency "cuprite", '~> 0.11', '>= 0.11'
  s.add_runtime_dependency "nokogiri", '~> 1.10', '>= 1.10.8'
end
