#!/bin/sh
# ossec-nagios.sh
#
AWK=/bin/awk
CAT=/bin/cat
CUT=/bin/cut
ECHO=/bin/echo
GREP=/bin/grep
SED=/bin/sed
TR=/bin/tr
#
ALERTID=$4
ACTIVELOG=/var/ossec/logs/active-responses.log
ALERTLOG=/var/ossec/logs/alerts/alerts.log
#
$ECHO "`date` $0 $1 $2 $3 $4 $5 $6 $7 $8" >> $ACTIVELOG
CONTENT=`$CAT $ALERTLOG | $GREP -A 10 "$ALERTID" | $GREP -v "$ALERTID" -A 10 | $TR '\r\n' ' ' | $TR -cd "'[:alnum:] :./-" | $CUT -c -340`
HEADER=`$CAT $ALERTLOG | $GREP "$ALERTID" | $TR -cd "'[:alnum:] ,:./-"`
LVL=`$ECHO "$CONTENT" | $SED -n '1,4s/^.*level \([0-9]*\).*$/\1/p'`
if [ $LVL -ge 10 ]; then CODE=2; else CODE=1; fi
#
GROUP=`$ECHO "$HEADER" | $GREP 'Alert' | $AWK {'print $5'} | $AWK -F"," {'print $1'}`
if [ "$GROUP" = firewall ]; then
 FAC="FW"
elif [ "$GROUP" = network ]; then
 FAC="NET"
else
 FAC="UNIX"
fi
#
CMD="/usr/local/nagios/var/rw/nagios.cmd"
DATE=`date +%s`
CMD_LINE="[$DATE] PROCESS_SERVICE_CHECK_RESULT;machina;OSSEC $FAC;$CODE;$CONTENT"
$ECHO $CMD_LINE >> $CMD
CMD_LINE="[$DATE] PROCESS_SERVICE_CHECK_RESULT;machina;OSSEC $FAC;0;'Alert cleared'"
$ECHO $CMD_LINE >> $CMD
#
exit
