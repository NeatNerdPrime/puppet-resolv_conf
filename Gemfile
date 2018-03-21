source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :test do
  gem 'metadata-json-lint',     :require => false
  gem 'puppet-lint',            :require => false
  gem 'puppet_facts',           :require => false
  gem 'puppetlabs_spec_helper', :require => false
  gem 'rspec-puppet',           :require => false
  gem 'rspec-puppet-facts',     :require => false
  gem 'rspec-puppet-utils',     :require => false
  gem 'rubocop',                :require => false
  gem 'rubocop-rspec',          :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false, :groups => [:test]
else
  gem 'puppet', :require => false, :groups => [:test]
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false, :groups => [:test]
else
  gem 'facter', :require => false, :groups => [:test]
end
