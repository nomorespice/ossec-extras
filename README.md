## Table of Contents


  * [ossec-discord.sh](#ossec-discord.sh)
  * [cis_debian_linux_rcl.txt](#cis_debian_linux_rcl.txt)
  * [cis_rhel7_linux_rcl.txt](#cis_rhel7_linux_rcl.txt)
  
## <a name="ossec-discord.sh"></a>ossec-discord.sh

ossec-discord.sh is part of the OSSEC active response functionality.
This has been tested using Ubuntu 18.04 and OSSEC version 2.9.3.

__Usage__

On the OSSEC server, place ossec-discord.sh into your $OSSEC_HOME/active-response/bin directory. Ensure your $OSSEC_HOME/active-response/bin/ossec-discord.sh
file is owned by user ossec and group ossec. Ensure this file is also executable. 

Next, configure OSSEC to use this script for alerting:

__Example__

```
  <command>
    <name>ossec-discord</name>
    <executable>ossec-discord.sh</executable>
    <timeout_allowed>no</timeout_allowed>
    <expect />
  </command>

  <active-response>
    <command>ossec-discord</command>
    <location>server</location>
    <level>7</level>
  </active-response>
```
