require 'serverspec'
# Set backend type
set :backend, :exec
# Don't include Specinfra::Helper::DetectOS

set :path, '/sbin:/usr/sbin:$PATH'

# Have the modules been loaded?
['zfs','spl'].each do |mod|
  describe kernel_module(mod) do
    it { should be_loaded }
  end
end

#Does the device exist, with the correct permissions?
describe file('/dev/zfs') do
  it { should be_owned_by 'root' }
  it { should be_mode '600'}
end

# Has the pool been created?
describe zfs('tank') do
  it { should exist }
end

# Are the correct snapshots present?
describe command('/sbin/zfs list -t snapshot -d 1 -r tank/test') do
  its(:stdout) { should match /zfs-chef-snap-test5/ }
  its(:stdout) { should match /zfs-chef-snap-test6/ }
  its(:stdout) { should match /zfs-chef-snap-serverspec/ }
  #
  its(:stdout) { is_expected.not_to match /zfs-chef-snap-test3/ }
end
