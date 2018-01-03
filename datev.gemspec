# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'datev/version'

Gem::Specification.new do |spec|
  spec.name          = "datev"
  spec.version       = Datev::VERSION
  spec.authors       = ["Georg Ledermann"]
  spec.email         = ["mail@georg-ledermann.de"]

  spec.summary       = %q{Export booking data in DATEV format}
  spec.description   = %q{Provides an easy way to create CSV files which can be imported into accounting applications}
  spec.homepage      = "https://github.com/ledermann/datev"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.2.0'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
end
