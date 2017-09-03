require_relative '../../../../spec_helper'

describe 'govuk_docker::swarm', :type => :define do
  let(:title) { 'bella' }
  let(:facts) {{ :hostname => 'dockerhost' }}

  context 'as a manager with manager token set' do
    let(:params) {{
      :role        => 'manager',
      :manager_ips => ['1.2.3.4'],
      :manager_token => 'token123',
      }}
    it { is_expected.to contain_file('/usr/local/bin/swarm_create_cluster') }
    it { is_expected.to contain_file('/usr/local/bin/swarm_manager_join').with_content(
      /for manager in 1\.2\.3\.4/
    ) }
  end
  context 'as a worker with worker token set' do
    let(:params) {{
      :role => 'worker',
      :manager_ips => ['1.2.3.4'],
      :worker_token => 'token123',
      }}
    it { is_expected.to contain_file('/usr/local/bin/swarm_worker_join').with_content(
      /for manager in 1\.2\.3\.4/
    ) }
    it { is_expected.to contain_exec('Swarm worker join') }
  end
end
