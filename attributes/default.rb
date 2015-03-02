default['zol']['zfs_repo']                                         = "https://github.com/zfsonlinux/zfs.git"
default['zol']['spl_repo']                                         = "https://github.com/zfsonlinux/spl.git"
default['zol']['zfs_commit']                                       = "07dabd234dd51a1e5adc5bd21cddf5b5fdc70732"
default['zol']['spl_commit']                                       = "31cb5383bff0fddc5058973e32a6f2c446d45e59"

default['zol']['dev_group']                                        = "root"
default['zol']['dev_perms']                                        = "600"

case node['platform_version']
when '12.04'
  default['zol']['mountall_url']                                   = "http://ppa.launchpad.net/zfs-native/daily/ubuntu/pool/main/m/mountall/mountall_2.36.4-zfs2_amd64.deb"
  default['zol']['mountall_checksum']                              = "21c48d17d76bbc83b58ba4c62f26bb7c9dd5e7cdab7bb100eb9ed417194da97b"
when '14.04'
  default['zol']['mountall_url']                                   = "http://ppa.launchpad.net/zfs-native/daily/ubuntu/pool/main/m/mountall/mountall_2.53-zfs1_amd64.deb"
  default['zol']['mountall_checksum']                              = "87f33148dd06f861f757f472464a60015bac3595ad73e4deac7a1968adec356d"
end
