#!/bin/sh
function get_cmd() {
  echo 'acpid auditdi autofs avahi-daemon bluetooth cups firstboot gpm hidd ip6tables mcstrans mdmonitor netfs nfslock pcscd restorecond rpcgssd rpcidmapd sendmail xfs yum-updatesd'
}
for cmd in `get_cmd`; do
  chkconfig $cmd off
  /etc/init.d/$cmd stop
done
