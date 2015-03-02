#
# Cookbook Name:: zfs_linux
# Provider:: snapshot
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

include ZoLMethods

use_inline_resources

def load_current_resource
  # Instantiate and populate our @current_resource object
  @current_resource = Chef::Resource::ZfsLinuxSnapshot.new(new_resource.name)
  @current_resource.name(new_resource.name)
  # If the dataset has been specified, operate on it; otherwise, assume
  # it's the name of the resource
  dataset = new_resource.dataset ? new_resource.dataset : new_resource.name
  @current_resource.snaps = list_snapshots(dataset, search=new_resource.prefix)
end

action :create do
  # If the dataset has been specified, operate on it; otherwise, assume
  # it's the name of the resource
  t = Time.new
  dataset = new_resource.dataset ? new_resource.dataset : new_resource.name
  suffix = new_resource.append_timestamp ? "-#{t.strftime('%Y-%m-%d-%H%M')}" : ''
  snapshot = "#{dataset}@#{new_resource.prefix}#{suffix}"
  if !@current_resource.snaps.include?(snapshot) and zfs_installed?
    execute "create_#{snapshot}" do
      command "/sbin/zfs snapshot #{snapshot}"
    end
    new_resource.updated_by_last_action(true)
  end
end

action :prune do
  if (@current_resource.snaps.count > new_resource.snaps_to_retain.to_i) and zfs_installed?
    while @current_resource.snaps.count > new_resource.snaps_to_retain.to_i
      snap = @current_resource.snaps.sort.first
      execute "delete_#{snap}" do
        command "/sbin/zfs destroy #{snap}"
      end
      @current_resource.snaps.delete(snap)
    end
    new_resource.updated_by_last_action(true)
  end
end

action :purge do
  # Delete All The Snapshots
  if (@current_resource.snaps.count > 0) and zfs_installed?
    @current_resource.snaps.each do |snap|
      execute "delete_#{snap}" do
        command "/sbin/zfs destroy #{snap}"
      end
      @current_resource.snaps.delete(snap)
    end
    new_resource.updated_by_last_action(true)
  end
end
