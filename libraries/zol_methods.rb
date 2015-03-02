#
# Cookbook Name:: zfs_linux
# Library:: zol_methods
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

require 'mixlib/shellout'

module ZoLMethods
  # Returns an array of the snapshots for a given ZFS filesystem
  def list_snapshots (filesystem, search=nil)
    if File.exist?('/sbin/zfs')
      filter = search ? " | grep #{search}" : ''
      command = Mixlib::ShellOut.new("/sbin/zfs list -H -d 1 -t snapshot -o name -s name #{filesystem}#{filter}")
      command.run_command
      command.stdout.strip.split
    else
      []
    end
  end
  def zfs_installed?
    File.exist?('/sbin/zfs') ? true : false
  end
end
