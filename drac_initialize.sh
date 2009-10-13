#!/bin/sh

if [ x"$1" = "x" ]; then
    echo "Usage `basename $0` <DRAC unique ID>"
    exit -1
fi

DRAC_ID=$1
HOSTNAME=drac$DRAC_ID.example.com
USER=root
PASSWORD="<%= drac_password %>"
DNS1=<%= drac_dns1 %>
DNS2=0.0.0.0
DOMAIN=<%= domain %>
ALERT=<%= alert_email %>
SMTP_SERVER=<%= drac_smtp_server %>
FW_UPDATE_SERVER=<%= drac_fw_update_server %>

expect -c "
set timeout 20
spawn ssh $USER@$HOSTNAME
expect *password:
send \"$PASSWORD\r\"
set timeout 5
expect \"\[root\]# \"
send \"racadm config -g cfgLanNetworking -o cfgDNSServer1 $DNS1\r\"
expect \"\[root\]# \"
send \"racadm config -g cfgLanNetworking -o cfgDNSServer2 $DNS2\r\"

expect \"\[root\]# \"
send \"racadm config -g cfgLanNetworking -o cfgDNSRacName drac$DRAC_ID\r\"
expect \"\[root\]# \"
send \"racadm config -g cfgLanNetworking -o cfgDNSDomainName $DOMAIN\r\"
expect \"\[root\]# \"
send \"racadm getconfig -g cfgLanNetworking\r\"

expect \"\[root\]# \"
send \"racadm config -g cfgUserAdmin -i 1 -o cfgUserAdminEmailEnable 1\r\"
expect \"\[root\]# \"
send \"racadm config -g cfgUserAdmin -i 1 -o cfgUserAdminEmailAddress $ALERT\r\"
expect \"\[root\]# \"
send \"racadm config -g cfgUserAdmin -i 1 -o cfgUserAdminEmailCustomMsg drac$DRAC_ID\r\"
expect \"\[root\]# \"
send \"racadm getconfig -g cfgUserAdmin -i 1\r\"

expect \"\[root\]# \"
send \"racadm config -g cfgRemoteHosts -o cfgRhostsSmtpServerIpAddr $SMTP_SERVER\r\"
expect \"\[root\]# \"
send \"racadm config -g cfgRemoteHosts -o cfgRhostsFwUpdateIpAddr $FW_UPDATE_SERVER\r\"
expect \"\[root\]# \"
send \"racadm getconfig -g cfgRemoteHosts\r\"

expect \"\[root\]# \"
send \"racadm config -g cfgEmailAlert -i 1 -o cfgEmailAlertEnable 1\r\"
expect \"\[root\]# \"
send \"racadm config -g cfgEmailAlert -i 1 -o cfgEmailAlertAddress $ALERT\r\"
expect \"\[root\]# \"
send \"racadm config -g cfgEmailAlert -i 1 -o cfgEmailAlertCustomMsg drac$DRAC_ID\r\"
expect \"\[root\]# \"
send \"racadm getconfig -g cfgEmailAlert -i 1\r\"
expect \"\[root\]# \"
send \"racadm testemail -i 1\r\"

expect \"\[root\]# \"
send \"racadm config -g cfgIpmiSerial -o cfgIpmiSerialBaudRate 57600\r\"
expect \"\[root\]# \"
send \"racadm getconfig -g cfgIpmiSerial\r\"

expect \"\[root\]# \"
send \"racadm config -g cfgSerial -o cfgSerialBaudRate 57600\r\"
expect \"\[root\]# \"
send \"racadm config -g cfgSerial -o cfgSerialTelnetEnable 1\r\"
expect \"\[root\]# \"
send \"racadm getconfig -g cfgSerial\r\"

expect \"\[root\]# \"
send \"racadm config -g cfgIpmiSol -o cfgIpmiSolBaudRate 57600\r\"
expect \"\[root\]# \"
send \"racadm getconfig -g cfgIpmiSol\r\"

expect \"\[root\]# \"
send \"exit\r\"
"
