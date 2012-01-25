#!/bin/sh
function get_services() {
  echo 'acpid auditdi autofs avahi-daemon bluetooth cups firstboot gpm hidd ip6tables iscsi iscsid mcstrans mdmonitor netfs nfslock pcscd restorecond rpcgssd rpcidmapd sendmail xfs yum-updatesd'
}

function get_virt_services() {
  echo 'acpid apmd autofs cpuspeed cups gpm isdn kudzu mdmonitor microcode_ctl pcmcia rawdevices readahead readahead_early smartd'
}

for cmd in `get_services`; do
  /sbin/chkconfig $cmd off
  /etc/init.d/$cmd stop
done

for cmd in `get_virt_services`; do
  /sbin/chkconfig $cmd off
  /etc/init.d/$cmd stop
done