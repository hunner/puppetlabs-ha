require 'spec_helper'

describe 'ha', :type => :class do
  let(:facts) do
    {
      :ipaddress      => '10.0.0.2',
      :concat_basedir => '/dne'
    }
  end
  let(:params) do
    {
      :cluster => 'mock_cluster',
      :disk    => '/dev/mock_disk',
      :members => ['10.0.0.3','10.0.0.2']
    }
  end
  it { should include_class('ha') }
  it { should_not include_class('ha::util::corosync') }
  it { should_not include_class('ha::util::drbd') }
end
