# -*- encoding: utf-8 -*-
require File.expand_path('../lib/config_leaf/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bil Bas (Spooner)"]
  gem.email         = ["bil.bagpuss@gmail.com"]
  gem.description   = <<END
ConfigLeaf allows an object to be configured using a terse syntax
like Object#instance_eval, while not exposing the internals
(protected/private methods and ivars) of the object!
END
  gem.summary       = %q{Terse configuration syntax for objects}
  gem.homepage      = "https://github.com/spooner/config_leaf"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "config_leaf"
  gem.require_paths = ["lib"]
  gem.version       = ConfigLeaf::VERSION

  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "rr", "~> 1.0.4"
  gem.add_development_dependency "yard", "~> 0.8.3"
  gem.add_development_dependency "redcarpet", "~> 2.1.1"
end
