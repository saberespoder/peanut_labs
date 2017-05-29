# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'peanut_labs/version'

Gem::Specification.new do |spec|
  spec.name          = "peanut_labs"
  spec.version       = PeanutLabs::VERSION
  spec.authors       = ["Stanislav K"]
  spec.email         = ["tech@saberespoder.com"]

  spec.summary       = "Gem for integration with peanutlabs.com"
  spec.description   = "Simple library for integration with peanutlabs.com website"
  spec.homepage      = "http://www.github.com/saberespoder/peanut_labs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.4"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "timecop", "~> 0.8"
end
