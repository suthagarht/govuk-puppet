require_relative '../../../../spec_helper'

describe 'nginx::log', :type => :define do
  context 'absolute filename as title' do
    let(:title) { '/var/log/nginx/caterpillar.log' }
    it { is_expected.to raise_error(Puppet::Error, /validate_re/) }
  end
end
