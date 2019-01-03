lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activek8s/version'

Gem::Specification.new do |spec|
  spec.name          = 'activek8s'
  spec.version       = Activek8s::VERSION
  spec.authors       = ['Fernando Valverde Arredondo']
  spec.email         = ['fdov88@gmail.com']

  spec.summary       = 'Kubernetes integration to Rails apps via Rake tasks'
  spec.description   = 'Kubernetes integration to Rails apps via Rake tasks'
  spec.homepage      = 'https://github.com/fdoxyz/activek8s'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been
  # added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'pry-byebug', '~> 3.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.59.0'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
end
