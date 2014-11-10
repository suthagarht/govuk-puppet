require_relative '../../../../spec_helper'

describe 'nginx', :type => :class do
  it do
    should contain_package('nginx').with_ensure('purged')
    should contain_package('nginx-full').with_ensure('present')
  end
end
