# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rokko/version"

Gem::Specification.new do |s|
  s.name        = "rokko"
  s.version     = Rokko::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Vasily Polovnyov"]
  s.email       = ["vasily@polovnyov.ru"]
  s.homepage    = "http://vast.github.com/rokko/"
  s.summary     = %q{Else one ruby port of [Docco](http://jashkenas.github.com/docco/)}
  s.description = %q[fat-free [rocco](http://rtomayko.github.com/rocco/)]

  s.rubyforge_project = "rokko"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency('mustache')
  s.add_dependency('rdiscount')
end
