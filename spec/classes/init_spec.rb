require 'spec_helper'

describe 'resolv_conf' do
  on_supported_os.each do |os, facts|
    context "on #{os} with default values for all parameters" do
      let(:facts) { facts }

      it {
        is_expected.to contain_class('resolv_conf')
        is_expected.to contain_file('/etc/resolv.conf')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(%r{^nameserver 127.0.0.1$})
          .without_content(%r{^search})
          .without_content(%r{^sortlist})
          .without_content(%r{^options})
      }
    end

    context "on #{os} with different resolv_conf_file" do
      let(:facts) { facts }
      let(:params) do
        { resolv_conf_file: '/run/resolv.conf' }
      end

      it {
        is_expected.to contain_file('/run/resolv.conf')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(%r{^nameserver 127.0.0.1$})
          .without_content(%r{^search})
          .without_content(%r{^sortlist})
          .without_content(%r{^options})
      }
    end

    context "on #{os} with owner, group & mode defined" do
      let(:facts) { facts }
      let(:params) do
        { owner: 'owner', group: 'group', mode: '1246' }
      end

      it {
        is_expected.to contain_file('/etc/resolv.conf')
          .with_owner('owner')
          .with_group('group')
          .with_mode('1246')
          .with_content(%r{^nameserver 127.0.0.1$})
          .without_content(%r{^search})
          .without_content(%r{^sortlist})
          .without_content(%r{^options})
      }
    end

    context "on #{os} with parameter sortlist" do
      let(:facts) { facts }
      let(:params) do
        { sortlist: ['foo', 'bar'] }
      end

      it {
        is_expected.to contain_file('/etc/resolv.conf')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(%r{^nameserver 127.0.0.1$})
          .without_content(%r{^search})
          .with_content(%r{^sortlist foo bar$})
          .without_content(%r{^options})
      }
    end

    context "on #{os} with one nameserver" do
      let(:facts) { facts }
      let(:params) do
        { nameservers: ['8.8.8.8'] }
      end

      it {
        is_expected.to contain_file('/etc/resolv.conf')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(%r{^nameserver 8.8.8.8$})
          .without_content(%r{^search})
          .without_content(%r{^sortlist})
          .without_content(%r{^options})
      }
    end

    context "on #{os} with two nameservers" do
      let(:facts) { facts }
      let(:params) do
        { nameservers: ['8.8.8.8', '8.8.4.4'] }
      end

      it {
        is_expected.to contain_file('/etc/resolv.conf')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(%r{^nameserver 8.8.8.8$})
          .with_content(%r{^nameserver 8.8.4.4$})
          .without_content(%r{^search})
          .without_content(%r{^sortlist})
          .without_content(%r{^options})
      }
    end

    context "on #{os} with three nameservers" do
      let(:facts) { facts }
      let(:params) do
        { nameservers: ['8.8.8.8', '8.8.4.4', '9.9.9.9'] }
      end

      it {
        is_expected.to contain_file('/etc/resolv.conf')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(%r{^nameserver 8.8.8.8$})
          .with_content(%r{^nameserver 8.8.4.4$})
          .with_content(%r{^nameserver 9.9.9.9$})
          .without_content(%r{^search})
          .without_content(%r{^sortlist})
          .without_content(%r{^options})
      }
    end

    context "on #{os} with four nameservers" do
      let(:facts) { facts }
      let(:params) do
        { nameservers: ['8.8.8.8', '8.8.4.4', '9.9.9.9', '9.9.9.10'] }
      end

      it {
        is_expected.to raise_error(Puppet::Error, %r{Evaluation Error})
      }
    end

    context "on #{os} with truthy prepend_local_nameserver" do
      let(:facts) { facts }
      let(:params) do
        { nameservers: ['8.8.8.8'], prepend_local_nameserver: true }
      end

      it {
        is_expected.to contain_file('/etc/resolv.conf')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(%r{^nameserver 127.0.0.1$})
          .with_content(%r{^nameserver 8.8.8.8$})
          .without_content(%r{^search})
          .without_content(%r{^sortlist})
          .without_content(%r{^options})
      }
    end

    context "on #{os} with three nameservers and truthy prepend_local_nameserver" do
      let(:facts) { facts }
      let(:params) do
        {
          nameservers: ['8.8.8.8', '8.8.4.4', '9.9.9.9'],
          prepend_local_nameserver: true,
        }
      end

      it {
        is_expected.to contain_file('/etc/resolv.conf')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(%r{^nameserver 127.0.0.1$})
          .with_content(%r{^nameserver 8.8.8.8$})
          .with_content(%r{^nameserver 8.8.4.4$})
          .without_content(%r{^search})
          .without_content(%r{^sortlist})
          .without_content(%r{^options})
      }
    end

    context "on #{os} with falsy prepend_local_nameserver" do
      let(:facts) { facts }
      let(:params) do
        { nameservers: ['8.8.8.8'], prepend_local_nameserver: false }
      end

      it {
        is_expected.to contain_file('/etc/resolv.conf')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(%r{^nameserver 8.8.8.8$})
          .without_content(%r{^search})
          .without_content(%r{^sortlist})
          .without_content(%r{^options})
      }
    end

    context "on #{os} with parameter searchlist" do
      let(:facts) { facts }
      let(:params) do
        { searchlist: ['foo', 'bar'] }
      end

      it {
        is_expected.to contain_file('/etc/resolv.conf')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(%r{^nameserver 127.0.0.1$})
          .with_content(%r{^search foo bar$})
          .without_content(%r{^sortlist$})
          .without_content(%r{^options})
      }
    end

    context "on #{os} with too many searchlist items" do
      let(:facts) { facts }
      let(:params) do
        { searchlist: ['foo', 'bar', 'baz', 'qux', 'quux', 'quuz', 'corge'] }
      end

      it {
        is_expected.to raise_error(Puppet::Error, %r{Evaluation Error})
      }
    end

    context "on #{os} with parameter domainname" do
      let(:facts) { facts }
      let(:params) do
        { domainname: 'example.com' }
      end

      it {
        is_expected.to contain_file('/etc/resolv.conf')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(%r{^nameserver 127.0.0.1$})
          .with_content(%r{^search example\.com$})
          .without_content(%r{^sortlist$})
          .without_content(%r{^options})
      }
    end

    context "on #{os} with domainname and searchlist" do
      let(:facts) { facts }
      let(:params) do
        { domainname: 'example.com', searchlist: ['example.com', 'example.net'] }
      end

      it {
        is_expected.to raise_error(Puppet::Error, %r{The searchlist and domain settings are mutually exclusive})
      }
    end

    context "on #{os} with valid parameter options" do
      let(:facts) { facts }
      let(:params) do
        { options: ['ndots:1', 'timeout:30', 'attempts:5'] }
      end

      it {
        is_expected.to contain_file('/etc/resolv.conf')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(%r{^nameserver 127.0.0.1$})
          .without_content(%r{^search})
          .without_content(%r{^sortlist$})
          .with_content(%r{^options ndots:1$})
          .with_content(%r{^options timeout:30$})
          .with_content(%r{^options attempts:5$})
      }
    end

    context "on #{os} with invalid parameter options" do
      let(:facts) { facts }
      let(:params) do
        { options: ['foo'] }
      end

      it {
        is_expected.to raise_error(Puppet::Error, %r{Invalid option})
      }
    end
  end
end
