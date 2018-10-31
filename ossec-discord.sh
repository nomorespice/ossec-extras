#!/bin/bash
# ossec-discord.sh
#
# URL is provided by the Discord's WebHook: https://discordapp.com/api/webhooks/TOKEN"
#
AWK=/usr/bin/awk
CAT=/bin/cat
CURL=/usr/bin/curl
CUT=/usr/bin/cut
GREP=/bin/grep
ECHO=/bin/echo
PRINTF=/usr/bin/printf
SED=/bin/sed
STRINGS=/usr/bin/strings
TAC=/usr/bin/tac
TR=/usr/bin/tr
#
ACTIVELOG=/var/ossec/logs/active-responses.log
ALERTLOG=/var/ossec/logs/alerts/alerts.log
TYPE=`$ECHO '"Content-Type: application/json"'`
URL="WEBHOOK"
ALERTID=$4
RULEID=$5
$ECHO "`date` $0 $1 $2 $3 $4 $5 $6 $7 $8" >> $ACTIVELOG
ALERTFULL=`$CAT $ALERTLOG | $STRINGS | $GREP -A 10 "$ALERTID" | $GREP -v "$ALERTID" -A 10 | $GREP -v "Src IP: " | $GREP -v "User: " | $GREP "Rule: " -A 4 | $CUT -c -139 | $SED 's/\"//g'`
CONTENT=`$ECHO -n "$ALERTFULL" | $SED '1!G;h;$!d' | $SED -e 's/[;,()'\''<>]//g;s/\[/ /;s/\]//'`
LVL=`$ECHO -e "$CONTENT" | $AWK -F"level " {'print $2'} | $AWK {'print $1'}`
if [ "$LVL" -ge 1 -a "$LVL" -le 7 ]; then CLR="255";
elif [ "$LVL" -ge 8 -a "$LVL" -le 10 ]; then CLR="16776960";
elif [ "$LVL" -ge 11 -a "$LVL" -le 13 ]; then CLR="16711680";
fi
CON1=`$ECHO -n "\"$CONTENT\""`
$PRINTF "curl -s -X POST --data '{ \"embeds\": [{\"color\": \"$CLR\", \"description\": $CON1 }] }' -H $TYPE $URL" | $TR -d "\n\r" | /bin/bash
#
exit
