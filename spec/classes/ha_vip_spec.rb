require 'spec_helper'

describe 'ha::vip', :type => :class do
  let(:facts) do
    {
      :ipaddress      => '10.0.0.2',
      :concat_basedir => '/dne',
      :ha_cluster     => 'mock_cluster',
      :ha_disk        => '/dev/mock0'
    }
  end
  let(:params) do
    { :vip => '23.23.23.23' }
  end
  it { should contain_class('ha::vip') }
end
