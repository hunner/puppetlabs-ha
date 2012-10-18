require 'spec_helper'

describe 'ha::mysql', :type => :class do
  let(:default_facts) do
    {
      :osfamily       => 'Debian',
      :ipaddress      => '10.0.0.2',
      :concat_basedir => '/dne',
      :ha_cluster     => 'mock_cluster',
      :ha_disk        => '/dev/mock0'
    }
  end
  let(:params) do
    {
      :vip     => '23.23.23.23'
    }
  end
  context "without exported resources" do
    let(:facts) do default_facts end
    it { should contain_class('ha::mysql') }
    it { should contain_class('ha::util::drbd').with(
      'mountpoint' => '/var/lib/mysql',
    ) }
    it { should_not contain_class('ha::util::corosync') }
    it { should_not contain_class('mysql::server') }
    it { should_not contain_drbd__resource__up('puppet_ha') }
  end
  context "primary node with exported resources" do
    let(:facts) do { :ha_primary => 'true' }.merge default_facts end
    let(:exported_resources) do
      { 'concat::fragment' => { 'puppet_ha mock_cluster secondary resource' => {
        :target => '/etc/drbd.d/puppet_ha.res',
      } } }
    end

    it { should contain_class('ha::mysql') }
    it { should contain_class('ha::util::drbd') }
    it { should contain_class('ha::util::corosync') }
    it { should contain_class('mysql::server') }
    it { should contain_drbd__resource__up('puppet_ha') }
  end
  context "secondary node with exported resources" do
    let(:facts) do default_facts end
    let(:exported_resources) do
      { 'concat::fragment' => { 'puppet_ha mock_cluster primary resource' => {
        :target => '/etc/drbd.d/puppet_ha.res',
      } } }
    end

    it { should contain_class('ha::mysql') }
    it { should contain_class('ha::util::drbd') }
    it { should contain_class('ha::util::corosync') }
    it { should contain_class('mysql::server') }
    it { should contain_drbd__resource__up('puppet_ha') }
  end
end
