#!/bin/sh

if [ x"$1" = "x" ]; then
    echo "Usage `basename $0` <Switch unique ID>"
    exit -1
fi

SWITCH_ID=$1
HOSTNAME=switch${SWITCH_ID}.example.com
USER=admin
PASSWORD=""
SNTP_SERVER=<%= switch_sntp_server %>

expect -c "
set timeout 5
spawn telnet $HOSTNAME
expect \"*User Name:\"
send \"$USER\r\"
expect *password:
send \"$PASSWORD\r\"

expect *#
send \"configure\r\"

expect *#
send \"hostname $HOSTNAME\r\"

expect *#
send \"clock source sntp\r\"
expect *#
send \"clock timezone +9 zone JST\r\"
expect *#
send \"sntp unicast client enable\r\"
expect *#
send \"sntp server $SNTP_SERVER\r\"

expect *#
send \"vlan database\r\"
expect *#
send \"vlan 2\r\"
expect *#
send \"exit\r\"

expect *#
send \"interface ethernet g41\r\"
expect *#
send \"switchport mode access\r\"
expect *#
send \"switchport access vlan 2\r\"
expect *#
send \"exit\r\"

expect *#
send \"interface ethernet g42\r\"
expect *#
send \"switchport mode access\r\"
expect *#
send \"switchport access vlan 2\r\"
expect *#
send \"exit\r\"

expect *#
send \"interface ethernet g43\r\"
expect *#
send \"switchport mode access\r\"
expect *#
send \"switchport access vlan 2\r\"
expect *#
send \"exit\r\"

expect *#
send \"interface ethernet g44\r\"
expect *#
send \"switchport mode access\r\"
expect *#
send \"switchport access vlan 2\r\"
expect *#
send \"exit\r\"

expect *#
send \"interface ethernet g45\r\"
expect *#
send \"switchport mode access\r\"
expect *#
send \"switchport access vlan 2\r\"
expect *#
send \"exit\r\"

expect *#
send \"interface ethernet g46\r\"
expect *#
send \"switchport mode access\r\"
expect *#
send \"switchport access vlan 2\r\"
expect *#
send \"exit\r\"

expect *#
send \"interface ethernet g39\r\"
expect *#
send \"channel-group 1 mode on\r\"
expect *#
send \"exit\r\"

expect *#
send \"interface ethernet g40\r\"
expect *#
send \"channel-group 1 mode on\r\"
expect *#
send \"exit\r\"

expect *#
send \"interface ethernet g47\r\"
expect *#
send \"channel-group 2 mode on\r\"
expect *#
send \"exit\r\"

expect *#
send \"interface ethernet g48\r\"
expect *#
send \"channel-group 2 mode on\r\"
expect *#
send \"exit\r\"

expect *#
send \"interface port-channel 2\r\"
expect *#
send \"switchport access vlan 2\r\"
expect *#
send \"exit\r\"

expect *# 
send \"exit\r\"
"
