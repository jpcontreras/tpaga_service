
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tpaga_service/api/version"

Gem::Specification.new do |spec|
  spec.name          = "tpaga_service"
  spec.version       = TpagaService::VERSION
  spec.authors       = ["Juan Contreras"]
  spec.email         = ["juan.contreras@packen.co"]
  spec.summary       = %q{TPaga API Ruby to Integreate with the payment gateway }
  spec.description   = %q{TPaga Payment Gateway API
[Learn about TPaga](https://tpaga.co)
}
  spec.homepage      = "https://rubygems.org/gems/tpaga_service"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/jpcontreras/tpaga_service"
    spec.metadata["changelog_uri"] = "https://github.com/jpcontreras/tpaga_service/CODE_OF_CONDUCT.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "faraday"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency 'faraday'
end
