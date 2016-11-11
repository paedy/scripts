#!/bin/bash
##############################################################
#  Script     : checkExternalIP.sh
#  Author     : paedy
#  Date       : 11.11.2016
#  Last Edited: 11.11.2016, paedy
#  Description: send a mail with the actual external IP-address 
##############################################################
# Purpose:
# - 
#
# Requirements:
# - deployed ip resolver script on the homepage
#
# Syntax: checkExternalIP
#
# Notes:
# - 
##############################################################

workpath="/tmp"
filename="externalIP"
logfile="externalIP.log"
dt=$(date)

externalIP_current=$(curl https://ip.miach.ch)
if test ! -f $workpath/$filename
  then
    echo "1.1.1.1" > $workpath/$filename
  fi

externalIP_old=$(head -n1 $workpath/$filename);

#echo $externalIP_current
#echo $externalIP_old

if [ -n "$externalIP_current" ];
  then
    if test "$externalIP_old" = "$externalIP_current";
      then
        echo "Externe IP-Adresse hat sich nicht geändert. Keine weiteren Aktionen."
        echo $dt  "Externe IP-Adresse hat sich nicht geändert. Keine weiteren Aktionen." >> $workpath/$logfile
      else
        echo $externalIP_current > $workpath/$filename
        echo $externalIP_current " Neue externe IP-Adresse erhalten. Sende Mail..."
        echo $dt $externalIP_current " Neue externe IP-Adresse erhalten. Sende Mail..." >> $workpath/$logfile

        echo Subject: IP-Adresse $externalIP_current | ssmtp paedy11@gmail.com
    fi
fi

tail -n50 $workpath/$logfile > $workpath/dummy.log
cat $workpath/dummy.log > $workpath/$logfile
rm $workpath/dummy.log
