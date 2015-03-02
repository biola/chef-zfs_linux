#
# Cookbook Name:: zfs_linux-test
# Recipe:: default
#
# Copyright 2015 Biola University
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Setup our ZFS filesystem
execute 'create_zfs_sparse_file' do
  command "truncate -s 1G #{Chef::Config[:file_cache_path]}/zfsdisk.img"
  not_if { File.exists?("#{Chef::Config[:file_cache_path]}/zfsdisk.img") }
  action :nothing
  subscribes :run, 'execute[load_zfs_module]'
  notifies :run, 'execute[create_zfs_loopback_device]', :immediately
end
execute 'create_zfs_loopback_device' do
  command "losetup /dev/loop0 #{Chef::Config[:file_cache_path]}/zfsdisk.img"
  action :nothing
  notifies :run, 'execute[create_zpool_tank]', :immediately
end
execute 'create_zpool_tank' do
  command '/sbin/zpool create tank /dev/loop0'
  action :nothing
  notifies :run, 'execute[create_zfs_test_filesystem]', :immediately
end
execute 'create_zfs_test_filesystem' do
  command '/sbin/zfs create tank/test'
  action :nothing
  notifies :create, 'zfs_linux_snapshot[zfs-chef-snap-test1]', :immediately
end

# Create a few snapshots on the filesystem
(1..6).each do |num|
  zfs_linux_snapshot "zfs-chef-snap-test#{num.to_s}" do
    dataset 'tank/test'
    action :nothing
    prefix "zfs-chef-snap-test#{num.to_s}"
    # Prune out 3 of the snapshots just created
    unless num == 6
      notifies :create, "zfs_linux_snapshot[zfs-chef-snap-test#{(num + 1).to_s}]", :immediately
    else
      notifies :prune, 'zfs_linux_snapshot[test_prune]', :immediately
    end
  end
end
zfs_linux_snapshot 'test_prune' do
  dataset 'tank/test'
  snaps_to_retain 3
  action :nothing
  prefix 'zfs-chef-snap-test'
  notifies :create, 'zfs_linux_snapshot[snap_for_serverspec]', :immediately
end

# Create a specifically named snapshot
zfs_linux_snapshot 'snap_for_serverspec' do
  dataset 'tank/test'
  action :nothing
  prefix 'zfs-chef-snap-serverspec'
  append_timestamp false
end
