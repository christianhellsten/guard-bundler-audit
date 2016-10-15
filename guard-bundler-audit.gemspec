# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "guard-bundler-audit"
  spec.version       = '0.1.4'
  spec.authors       = ["Christian Hellsten"]
  spec.email         = ["christian@aktagon.com"]
  spec.summary       = %q{guard + bundler-audit = security}
  spec.description   = %q{guard + bundler-audit = security}
  spec.homepage      = "https://github.com/christianhellsten/guard-bundler-audit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'guard',         '~> 2.0'
  spec.add_dependency 'bundler-audit', '>= 0.3.1'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
