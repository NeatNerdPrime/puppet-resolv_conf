require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'metadata-json-lint/rake_task'
require 'rubocop/rake_task'

PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.relative = true
PuppetLint.configuration.ignore_paths = ['spec/**/*.pp', 'pkg/**/*.pp']
