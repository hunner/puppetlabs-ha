require 'spec_helper'

describe 'ha.vip.mysql.host', :type => :host do
  let(:facts) do
    {
      :ipaddress       => '10.0.0.2',
      :osfamily        => 'Debian',
      :operatingsystem => 'Ubuntu',
      :concat_basedir  => '/dne'
    }
  end
  context 'without any resources exported' do
    it { should contain_class('ha::util::drbd').with(
      'mountpoint' => '/var/lib/mock'
    ) }
    it { should_not include_class('ha::util::corosync') }
    it { should_not contain_class('mysql::server') }
    it { should_not contain_cs_primitive('puppet_ha_mysqld') }
    it { should_not contain_cs_colocation('puppet_ha_mysqld-on-fs') }
    it { should_not contain_cs_colocation('puppet_ha_mysqld-on-ip') }
    it { should_not contain_cs_order('puppet_ha_mysqld-after-puppet_ha_fs') }
    it { should_not contain_cs_order('puppet_ha_mysqld-after-puppet_ha_ip') }
  end

  #context 'with exported resource' do
  #  it { should_not include_class('ha::util::corosync') }
  #  it { should contain_class('ha::util::drbd').with(
  #    'mountpoint' => '/var/lib/mock'
  #  ) }
  #  it { should contain_class('mysql::server').with(
  #    'manage_service' => false
  #  ) }
  #  it { should contain_class("mysql::config").with(
  #    'bind_address' => '23.23.23.23'
  #  ) }
  #  it { should contain_cs_primitive('puppet_ha_mysqld') }
  #  it { should contain_cs_colocation('puppet_ha_mysqld-on-fs') }
  #  it { should contain_cs_colocation('puppet_ha_mysqld-on-ip') }
  #  it { should contain_cs_order('puppet_ha_mysqld-after-puppet_ha_fs') }
  #  it { should contain_cs_order('puppet_ha_mysqld-after-puppet_ha_ip') }
  #end
end
