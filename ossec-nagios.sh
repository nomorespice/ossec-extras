#!/bin/sh
# ossec-nagios.sh
#
AWK=/bin/awk
CAT=/bin/cat
CUT=/bin/cut
ECHO=/bin/echo
GREP=/bin/grep
SED=/bin/sed
STRINGS=/usr/bin/strings
#
ALERTID=$4
ACTIVELOG=/var/ossec/logs/active-responses.log
ALERTLOG=/var/ossec/logs/alerts/alerts.log
#
$ECHO "`date` $0 $1 $2 $3 $4 $5 $6 $7 $8" >> $ACTIVELOG
ALERTFULL=`$CAT $ALERTLOG | $STRINGS | $GREP -A 10 "$ALERTID" | $GREP -v "$ALERTID" -A 10 | $GREP -v "Src IP: " | $GREP -v "User: " | $GREP "Rule: " -A 4 | $CUT -c -139 | $SED 's/\"//g'`
CONTENT=`$ECHO -n "$ALERTFULL" | $SED '1!G;h;$!d' | $SED -e 's/[;,()'\''<>]//g;s/\[/ /;s/\]//'`
ALERTLVL=`$ECHO "$ALERTFULL" | $SED -n '1,4s/^.*(level \([0-9]*\).*$/\1/p'`
if [ $ALERTLVL -ge 10 ]; then CODE=2; else CODE=1; fi
#
GROUP=`$ECHO "$ALERTFULL" | $GREP 'Alert' | $AWK {'print $6'} | $AWK -F"," {'print $1'}`
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
