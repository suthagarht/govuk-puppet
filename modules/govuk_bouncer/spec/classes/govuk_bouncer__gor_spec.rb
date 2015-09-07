require_relative '../../../../spec_helper'

describe 'govuk_bouncer::gor', :type => :class do
  let(:ip_address) { '127.0.0.1' }
  let(:args_default) {{
    '-input-raw'          => ':80',
    '-http-allow-method' => %w{GET HEAD OPTIONS},
  }}

  context 'default (disabled)' do
    let(:params) {{ }}

    it {
      should contain_class('govuk::gor').with({
        :enable => false,
      })
    }
  end

  context '#enabled' do
    let(:params) {{
      :enabled => true,
      :ip_address => ip_address,
    }}

    it {
      should contain_class('govuk::gor').with(
        :enable => true,
        :args           => args_default.merge({
          '-output-http' => ["http://#{ip_address}"],
        }),
      )
    }
  end

  context 'enabled but no staging IP is invalid' do
    let(:params) {{
      :enabled => true,
      :ip_address => 'not.an.ip.address',
    }}

    it {
      should contain_class('govuk::gor').with(
        :enable => false,
      )
    }
  end

  context 'enabled but no staging IP specified' do
    let(:params) {{
      :enabled => true,
    }}

    it {
      should contain_class('govuk::gor').with(
        :enable => false,
      )
    }
  end
end
