# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'with default parameters ', if: ['debian', 'redhat', 'ubuntu'].include?(os[:family]) do
  pp = <<-PUPPETCODE
  class { '::waypoint':
    archive_source => 'https://github.com/attachmentgenie/golang-waypoint/releases/download/v0.1.2/golang-waypoint_0.1.2_linux_x86_64.tar.gz',
    install_method => 'archive',
  }
PUPPETCODE

  it 'applies idempotently' do
    idempotent_apply(pp)
  end

  describe group('waypoint') do
    it { is_expected.to exist }
  end

  describe user('waypoint') do
    it { is_expected.to exist }
  end

  describe file('/opt/waypoint') do
    it { is_expected.to be_directory }
  end

  describe file('/opt/waypoint/waypoint') do
    it { is_expected.to be_file }
  end

  describe service('waypoint') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running.under('systemd') }
  end

  describe port(8080) do
    it { is_expected.to be_listening }
  end
end
