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

# Disable dns rebind protection
uci set dhcp.@dnsmasq[0].rebind_protection=0
uci commit dhcp

# Set init network config
cat <<'EOF'> /etc/config/network
config interface 'loopback'
        option ifname 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'

config globals 'globals'
        option ula_prefix 'fdd0:fb32:9b0c::/48'
        option packet_steering '1'

config interface 'lan'
        option type 'bridge'
        option proto 'static'
        option netmask '255.255.255.0'
        option ifname 'eth0 eth1 eth2 eth3'
        option stp '1'
        option ipaddr '172.16.252.1'
        option gateway '172.16.252.1'
        option broadcast '172.16.252.255'
        option dns '172.16.252.1'

config interface 'wan'
        option proto 'dhcp'
        option ifname 'eth4'

config interface 'vpn0'
        option ifname 'tun0'
        option proto 'none'
EOF

# Add "/etc/rc.local" script
cat <<'EOF'> /etc/rc.local
#!/bin/bash

PATH=/usr/sbin:/usr/bin:/sbin:/bin

ROOTFS_DISK=$(mount | grep -w '/' | grep 'ro' | awk {'print $1'})
if [ ${ROOTFS_DISK} ] ; then 
  fsck.ext4 -y ${ROOTFS_DISK}
  mount -o remount rw /
fi

if [ -b "/dev/sdb1" ]; then
  mkdir -p /data
  mount /dev/sdb1 /data
fi

if [ -f "/data/start.sh" ]; then
  /bin/bash /data/start.sh
fi

exit 0
EOF

exit 0
