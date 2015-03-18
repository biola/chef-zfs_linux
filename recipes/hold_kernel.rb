#
# Cookbook Name:: zfs_linux
# Recipe:: hold_kernel
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

case node['platform_family']
when 'debian'
  if node['platform_version'] == '12.04'
    kernelpkgs = ['linux-server', 'linux-image-server']
  else
    kernelpkgs = ['linux-generic', 'linux-image-generic']
  end
  kernelpkgs.each do |kernelpkg|
    execute "echo #{kernelpkg} hold | dpkg --set-selections" do
      not_if "dpkg --get-selections | grep '^#{kernelpkg}' | grep -q 'hold'"
    end
  end
end
