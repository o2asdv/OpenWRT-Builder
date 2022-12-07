#!/bin/bash

# Set default theme to luci-theme-argon
# uci set luci.main.mediaurlbase='/luci-static/argon'
# uci commit luci

# Disable opkg signature check
sed -i 's/option check_signature/# option check_signature/g' /etc/opkg.conf

# Disable IPV6 ula prefix
# sed -i 's/^[^#].*option ula/#&/' /etc/config/network

# Check file system during boot
uci set fstab.@global[0].check_fs=1
uci commit fstab

# Add "/etc/rc.local" script
cat <<'EOF'> /etc/rc.local
#!/bin/bash

PATH=/usr/sbin:/usr/bin:/sbin:/bin

ROOTFS_DISK=$(mount | grep -w '/' | grep 'ro' | awk {'print $1'})
if [ ${ROOTFS_DISK} ] ; then 
  fsck.ext4 -y ${ROOTFS_DISK}
  mount -o remount rw /
fi

if [ -f "/data/start.sh" ]; then
  /bin/bash /data/start.sh
fi

exit 0
EOF

exit 0
