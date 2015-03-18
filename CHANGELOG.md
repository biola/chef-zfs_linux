zfs_linux Cookbook CHANGELOG
========================
This file is used to list changes made in each version of the zfs_linux cookbook.

v2.1.1 (2015-03-18)
------------------
- Fix auto-scrub cron distribution for systems w/ 6-12 zpools

v2.1.0 (2015-03-02)
------------------
- Add udev rule for managing ZFS device permissions.
  - New `['zol']['dev_group']` and `['zol']['dev_perms']` attributes should optionally allow basic ZoL management by non-root users.

v2.0.0 (2014-11-14)
------------------
- Remove attribute driven snapshot-pruning recipe; replaced with zfs_linux_snapshot resource.
  - Previous deployments of the snapshot-pruning recipe will need to manually remove stale /etc/cron.daily/zfs-auto-prune... files.
- Dropped RHEL support for now
