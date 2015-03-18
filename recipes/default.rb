#
# Cookbook Name:: zfs_linux
# Recipe:: default
#
# Copyright 2015 Biola University
# Copyright 2012 Cameron Johnston
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

case node['platform']
when 'ubuntu'
  if node['platform_version'].to_f >= 10.04

    include_recipe 'apt'

    apt_repository 'zfs-native' do
      uri 'http://ppa.launchpad.net/zfs-native/stable/ubuntu'
      distribution node['lsb']['codename']
      components ['main']
      keyserver 'keyserver.ubuntu.com'
      key 'F6B0FC61'
      action :add
    end

    # Ensure headers for the current kernel are installed
    uname = Mixlib::ShellOut.new('uname -r')
    kernel = uname.run_command.stdout.chomp
    package "linux-headers-#{kernel}" do
      not_if { File.directory?("/usr/src/linux-headers-#{kernel}") }
    end

    package 'ubuntu-zfs' do
      action :install
      # Load module after udev rule is in place
    end

    execute 'load_zfs_module' do
      command 'modprobe zfs'
      action :nothing
    end

    group node['zol']['dev_group'] do
      system true
    end

    template '/etc/udev/rules.d/91-zfs-permissions.rules' do
      source '91-zfs-permissions.rules.erb'
      owner 'root'
      group 'root'
      variables mode: node['zol']['dev_perms'],
                group: node['zol']['dev_group']
      notifies :run, 'execute[load_zfs_module]', :immediately
    end

  end
end
