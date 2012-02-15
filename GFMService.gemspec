# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "GFMService/version"

Gem::Specification.new do |s|
  s.name        = "GFM-Service"
  s.version     = GFMService::VERSION
  s.authors     = ["Aldric Giacomoni"]
  s.email       = ["trevoke@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Let the real author worry about this}
  s.description = %q{Let the real author worry about this}

  s.rubyforge_project = "GFM-Service"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "test-unit"
  # s.add_development_dependency "rspec"

  s.add_runtime_dependency "mongrel"
  s.add_runtime_dependency "redcarpet"
  s.add_runtime_dependency "albino"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "pygments.rb" # Yep ... That's the name of the gem as of 02/2012
end
