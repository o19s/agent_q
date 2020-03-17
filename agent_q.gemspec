Gem::Specification.new do |s|
  s.name        = 'agent_q'
  s.version     = '0.0.11'
  s.date        = '2020-03-17'
  s.summary     = "Headless agent for test driven relevancy with Quepid.com"
  s.description = "A ruby agent that wraps PhantomJS that runs a specific Quepid Case and returns if your relevancy score meets or below a threshold."
  s.authors     = ["Eric Pugh"]
  s.email       = ['epugh@opensourceconnections.com']
  s.files       = ["lib/agent_q.rb"]
  s.executables = ["agent_q"]
  s.homepage    = 'http://rubygems.org/gems/agent_q'
  s.license     = 'MIT'

  s.add_runtime_dependency "capybara", '~> 3.31', '>= 3.31'
  s.add_runtime_dependency "poltergeist", '~> 1.18', '>= 1.18.1'
  s.add_runtime_dependency "nokogiri", '~> 1.10', '>= 1.10.8'
end
