redshift will not be able to react symlink due to apparmor restriction
fix:
-edit file : /etc/apparmor.d/local/usr.bin.redshift
-add line owner @{HOME}/.../redshift.conf r,
-reload service : sudo systemctl reload apparmor
