default['zol']['zfs_repo'] = 'https://github.com/zfsonlinux/zfs.git'
default['zol']['spl_repo'] = 'https://github.com/zfsonlinux/spl.git'
default['zol']['zfs_commit'] = 'd07a16360c1ee219b8820f80d035e56a18c58b84'
default['zol']['spl_commit'] = 'cd69f020e4b0f9c416dd07a264e48c9488a7633f'

default['zol']['dev_group'] = 'root'
default['zol']['dev_perms'] = '600'

case node['platform_version']
when '12.04'
  default['zol']['mountall_url'] = 'http://ppa.launchpad.net/zfs-native/daily/ubuntu/pool/main/m/mountall/mountall_2.36.4-zfs2_amd64.deb'
  default['zol']['mountall_checksum'] = '21c48d17d76bbc83b58ba4c62f26bb7c9dd5e7cdab7bb100eb9ed417194da97b'
when '14.04'
  default['zol']['mountall_url'] = 'http://ppa.launchpad.net/zfs-native/daily/ubuntu/pool/main/m/mountall/mountall_2.53-zfs1_amd64.deb'
  default['zol']['mountall_checksum'] = '87f33148dd06f861f757f472464a60015bac3595ad73e4deac7a1968adec356d'
end
