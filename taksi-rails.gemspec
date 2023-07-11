require_relative 'lib/taksi/rails/version'

Gem::Specification.new do |spec|
  spec.name        = 'taksi-rails'
  spec.version     = Taksi::Rails::VERSION
  spec.authors     = ['Israel Trindade']
  spec.email       = ['irto@outlook.com']

  spec.summary     = 'A rails engine/railtie to the Taksi framework.'
  spec.description = 'The oficial way to use Taksi framework in your rails application.'

  spec.files         = Dir['CHANGELOG.md', 'LICENSE', 'README.md', 'Rakefile', 'dry-rails.gemspec', 'lib/**/*', 'config/**/*', 'app/**/*']
  spec.bindir        = 'bin'
  spec.executables   = []
  spec.require_paths = ['lib']

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['source_code_uri'] = 'https://github.com/taksi-br/taksi-rails'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/taksi-br/taksi-rails/issues'

  spec.required_ruby_version = '>= 2.7.0'

  spec.add_dependency 'rails', '>= 7.0.3.1'
  spec.add_dependency 'taksi', '~> 0.2.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-rails'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
