zfs\_linux Cookbook
==================
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/biola/chef-zfs_linux)

Installs & configures zfs on Ubuntu.

Requirements
------------

Ubuntu 12.04+

Usage
-----
#### zfs\_linux::default
Just include `zfs_linux` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[zfs_linux]"
  ]
}
```

#### zfs\_linux::auto-snapshot
Installs the zfs-auto-snapshot package, which automatically sets up rotating snapshots (hourly snapshots kept for a day, daily snapshots kept for a month, etc).

#### zfs\_linux::auto-scrub
Uses cron.d (via the cron cookbook) to setup cron jobs on Sunday morning for each zpool. If greater than 4 zpools are present, runs the checks once a month on the first Sunday.

#### zfs\_linux::source
This recipe was developed to allow the deployment of ZoL from a specific commit. Apply it to your node to pull down the ZFS revision from git (specified in your node's attributes).

__WARNING:__ On Debian-family systems, the current build method will disable automatic updates for your kernel because the ZoL packages will be built for the kernel that is running at the time of compilation. Do not apply this without a process in place for monitoring security updates and applying them manually in the following manner:
1. Update your system kernel packages
2. Disable the auto-start of any services that depend on your ZoL-mounted volumes
3. Reboot into the new kernel
4. Delete the zfs & spl directories in /var/chef/cache/
5. Perform a chef-client run
6. Enable auto-start again for your node's services
7. Reboot

Resources/Providers
-----
### zfs_linux_snapshot
#### Actions

- `:create`: Creates a snapshot of the dataset
- `:prune`: Deletes a datasets snapshots down to a specified number of
  snapshots
- `:purge`: Deletes all snapshots for a dataset

#### Attribute Parameters

- `dataset`: Name of the zpool/fileset. Defaults to the resource name.
- `prefix`: String to prefix the snapshot name. Defaults to `zfs-chef-snap`.
  When pruning/purging snapshots, used to filter the list of snapshots
  to be deleted (set to `nil` to disable the search filter).
- `snaps_to_retain`: The number of snapshots to retain (only applies to
  the `:prune` action). Defaults to `31`
- `append_timestamp`: Boolean to determine whether a timestamp (in
  the form of `-YY-MM-DD-HHmm`) is appended to the snapshot prefix.
  Defaults to `true`

#### Examples
```ruby
# Create a snapshot with a specific name
zfs_linux_snapshot 'tank/mydataset' do
  prefix 'myweeklysnapshot'
  append_timestamp false
end

# Delete all snapshots that match 'weekly'
zfs_linux_snapshot 'tank/mydataset' do
  prefix 'weekly'
  action :purge
end

# Remove all but the last 6 monthly snapshots
zfs_linux_snapshot 'tank/mydataset' do
  prefix 'zfs-auto-snap_monthly'
  snaps_to_retain 6
  action :prune
end
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
 Copyright 2015, Biola University

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
