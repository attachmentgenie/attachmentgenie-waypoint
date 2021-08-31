require 'spec_helper'
describe 'waypoint' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('waypoint') }
        it { is_expected.to contain_anchor('waypoint::begin').that_comes_before('Class[waypoint::Install]') }
        it { is_expected.to contain_class('waypoint::install').that_comes_before('Class[waypoint::Config]') }
        it { is_expected.to contain_class('waypoint::config').that_notifies('Class[waypoint::Service]') }
        it { is_expected.to contain_class('waypoint::service').that_comes_before('Anchor[waypoint::end]') }
        it { is_expected.to contain_anchor('waypoint::end') }
        it { is_expected.to contain_group('waypoint') }
        it { is_expected.to contain_package('waypoint') }
        it { is_expected.to contain_service('waypoint') }
        it { is_expected.to contain_user('waypoint') }
      end
    end
  end
end
