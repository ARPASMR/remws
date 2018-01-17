#!/bin/bash

. /root/.bash_profile

. /etc/sysconfig/remwsgwyd

export HOME=/root/

service remwsgwyd stop
runuser -s /bin/bash root -c ulimit -S -c 0 > /dev/null 2>&1 ; /sbin/unlogremws > /root/log/unlogremws.log > /dev/null 2>&1
service remwsgwyd start
