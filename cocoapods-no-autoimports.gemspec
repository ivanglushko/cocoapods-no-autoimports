lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/cocoapods-no-autoimports/plugin/version'

Gem::Specification.new do |spec|
  spec.name          = "cocoapods-no-autoimports"
  spec.version       = CocoapodsNoAutoimports::VERSION
  spec.authors       = ["Ivan Glushko"]
  spec.email         = ["ivanglushkodev@yandex.ru"]
  spec.summary       = "A CocoaPods plugin for removing autoimported [UIKit/Cocoa/Foundation] headers."
  spec.homepage      = "https://github.com/ivanglushko/cocoapods-no-autoimports"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end