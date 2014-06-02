# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant/tools/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-tools"
  spec.version       = Vagrant::Tools::VERSION
  spec.authors       = ["Dennis Blommesteijn"]
  spec.email         = ["dennis@blommesteijn.com"]
  spec.summary       = %q{Tools for Vagrant}
  spec.description   = %q{Tools for Vagrant}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sys-proctable', "> 0.9"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
