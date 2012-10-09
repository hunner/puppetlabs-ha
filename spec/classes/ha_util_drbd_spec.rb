require 'spec_helper'

describe 'ha::util::drbd', :type => :class do
  let(:facts) do
    {
      :ipaddress      => '10.0.0.2',
      :concat_basedir => '/dne',
      :ha_cluster     => 'mock_cluster',
      :ha_disk        => '/dev/mock0'
    }
  end
  it { should contain_class('ha::util::drbd') }
end
