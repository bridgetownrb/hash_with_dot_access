require_relative "lib/hash_with_dot_access/version"

Gem::Specification.new do |spec|
  spec.name          = "hash_with_dot_access"
  spec.version       = HashWithDotAccess::VERSION
  spec.author        = "Bridgetown Team"
  spec.email         = "maintainers@bridgetownrb.com"

  spec.summary       = %q{Performance-oriented subclass of Hash which provides symbolized keys and method access}
  spec.homepage      = "https://github.com/bridgetownrb/hash_with_dot_access"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.1.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 13.0"
end
