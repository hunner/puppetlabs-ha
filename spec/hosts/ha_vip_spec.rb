require 'spec_helper'

describe 'ha.vip.host', :type => :host do
  let(:facts) do
    {
      :ipaddress       => '10.0.0.2',
      :osfamily        => 'Debian',
      :operatingsystem => 'Ubuntu',
      :concat_basedir  => '/dne'
    }
  end
  it { should include_class('ha::vip') }
  it { should include_class('ha::util::vip') }
  it { should include_class('ha::util::corosync') }
  it { should_not include_class('ha::util::drbd') }
  it { should contain_cs_primitive('puppet_ha_ip').with(
    'primitive_type' => 'IPaddr2'
  ) }
end
