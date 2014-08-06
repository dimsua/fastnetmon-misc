#!/bin/bash

#$1 client_ip_as_string
#$2 data_direction
#$3 pps_as_string
IP=$1
VZID=`/usr/sbin/vzlist -aH -o ctid,ip|/bin/grep -w $IP|/bin/awk '{print $1}'`
email_notify="my@email"

# check stdin type
if [ -t 0 ]; then
        if [ "$VZID" = "" ];then
            exit
        fi
     echo "Collect atack details"
else
    cat | mail -s "DDOS Guard: IP $1 blocked because $2 attack with power $3 pps" $email_notify;
    /usr/sbin/vzctl stop $VZID --fast
    /usr/sbin/vzctl set $VZID --ipdel $IP --save
    sleep 300
    /etc/init.d/fastnetmon restart
fi
