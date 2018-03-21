require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
require 'rspec-puppet-utils'

# rubocop:disable Style/MixinUsage
include RspecPuppetFacts
# rubocop:enable Style/MixinUsage

RSpec.configure do |c|
  c.default_facts = {
    hostname:        'foo',
    domain:          'example.com',
    fqdn:            'foo.example.com',
    osfamily:        'Debian',
    operatingsystem: 'Debian'
  }

  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
