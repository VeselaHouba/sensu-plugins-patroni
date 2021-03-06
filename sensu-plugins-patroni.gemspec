# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'
require 'sensu-plugins-patroni'

Gem::Specification.new do |s| # rubocop:disable Metrics/BlockLength
  s.authors                = ['Sensu-Plugins and contributors']
  s.date                   = Date.today.to_s
  s.description            = 'This plugin provides monitoring of patroni cluster.'
  s.email                  = '<veselahouba@googlegroups.com>'
  s.executables            = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  s.files                  = Dir.glob('{bin,lib}/**/*') + %w[LICENSE README.md CHANGELOG.md]
  s.homepage               = 'https://github.com/VeselaHouba/sensu-plugins-patroni'
  s.license                = 'MIT'
  s.metadata               = { 'maintainer' => 'sensu-plugin',
                               'development_status' => 'active',
                               'production_status' => 'unstable - testing recommended',
                               'release_draft' => 'false',
                               'release_prerelease' => 'false' }
  s.name                   = 'sensu-plugins-patroni'
  s.platform               = Gem::Platform::RUBY
  s.post_install_message   = 'This plugin is meant to be run as asset from bonsai'
  s.require_paths          = ['lib']
  s.required_ruby_version  = '>= 2.3.0'
  s.summary                = 'Sensu plugins patroni monitoring'
  s.test_files             = s.files.grep(%r{^(test|spec|features)/})
  s.version                = SensuPluginsPatroni::Version::VER_STRING

  s.add_runtime_dependency 'json',                       '~> 2.3'
  s.add_runtime_dependency 'rest-client',                '~> 2.1'
  s.add_runtime_dependency 'sensu-plugin',               '~> 4.0'
  s.add_runtime_dependency 'typhoeus',                   '>= 1.3.1', '< 1.5.0'

  s.add_development_dependency 'bundler',                '~> 2.1'
  s.add_development_dependency 'github-markup',          '~> 3.0'
  s.add_development_dependency 'json',                   '~> 2.3'
  s.add_development_dependency 'pry',                    '~> 0.10'
  s.add_development_dependency 'rake',                   '~> 13.0'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'redcarpet',              '~> 3.2'
  s.add_development_dependency 'rspec',                  '~> 3.1'
  s.add_development_dependency 'rubocop',                '~> 0.79.0'
  s.add_development_dependency 'yard',                   '~> 0.9.11'
end
