# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_lockable_by/version'

Gem::Specification.new do |spec|
  spec.name          = 'acts_as_lockable_by'
  spec.version       = ActsAsLockableBy::VERSION
  spec.authors       = ['Tarek N. Elsamni']
  spec.email         = ['tarek.samni@gmail.com']

  spec.summary       = 'Atomically lock resources from concurrent access'
  # rubocop:disable Metrics/LineLength
  spec.description   = 'A ruby gem to atomically lock resources to prevent concurrent/multiple lockers from accessing or editing the resource'
  # rubocop:enable Metrics/LineLength
  spec.homepage      = 'https://github.com/tareksamni/acts_as_lockable_by'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/tareksamni/acts_as_lockable_by'
    spec.metadata['changelog_uri'] = 'https://github.com/tareksamni/acts_as_lockable_by/commits/master'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', ['~> 5.0']
  spec.add_runtime_dependency 'redis', '~> 4'

  spec.add_development_dependency 'awesome_print', '~> 1.8'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'byebug', '~> 10.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.52'
  spec.add_development_dependency 'solargraph', '~> 0.28'
end
