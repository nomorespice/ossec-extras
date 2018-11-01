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

__Example ossec.conf__

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

## <a name="cis_rhel7_linux_rcl.txt"></a>cis_rhel7_linux_rcl.txt

cis_rhel7_linux_rcl.txt is part of the OSSEC system audit rootcheck functionality. This file has been updated for the latest version of the CIS RedHat Enterprise Linux 7 Benchmark: v2.2.0 - 12-27-2017

Some rules are not implemented.

This has been tested using OSSEC version 2.9.3.

__Usage__

On the OSSEC client, place cis_rhel7_linux_rcl.txt into your $OSSEC_HOME/etc/shared directory. Ensure your $OSSEC_HOME/etc/ossec.conf file is configured to use cis_rhel7_linux_rcl.txt.

__Example ossec.conf__

```
  <rootcheck>
    <system_audit>/var/ossec/etc/shared/cis_rhel7_linux_rcl.txt</system_audit>
  </rootcheck>
```

__Reset the rootcheck database__

On the OSSEC server, reset (clear) the rootcheck database with the following command:

```
$OSSEC_HOME/bin/rootcheck_control -u <id>
```

__Restart OSSEC client__

On the OSSEC client, restart the client with the following command:

```
$OSSEC_HOME/bin/ossec-control restart
```

__Report__

Once the rootcheck process has completed, view the report using the following command:

```
$OSSEC_HOME/rootcheck_control -i <id> -L
```

__Example Report__

```
[root@machine ~]# /var/ossec/bin/rootcheck_control -i 100 -L

Policy and auditing events for agent 'test (100) - fdfd:0:0:0::64/128':

Resolved events: 

** No entries found.

Last scan: 2018 May 21 10:30:00

System Audit: System Audit: Testing against the CIS Red Hat Enterprise Linux 7 Benchmark v2.2.0. File: /etc/redhat-release. Reference: CIS RHEL 7 Benchmark v2.2.0 .

System Audit: System Audit: {1.1.2} Filesystem Configuration - Ensure separate partition exists for /tmp (Scored). File: /etc/fstab. Reference: CIS RHEL 7 Benchmark v2.2.0 .

System Audit: System Audit: {1.1.6} Filesystem Configuration - Ensure separate partition exists for /var (Scored). File: /etc/fstab. Reference: CIS RHEL 7 Benchmark v2.2.0 .

System Audit: System Audit: {1.1.7} Filesystem Configuration - Ensure separate partition exists for /var/tmp (Scored). File: /etc/fstab. Reference: CIS RHEL 7 Benchmark v2.2.0 .

System Audit: System Audit: {1.2.5} Configure Software Updates - Disable the rhnsd Daemon (Not Scored). Process: rhnsd. Reference: CIS RHEL 7 Benchmark v2.2.0 .

System Audit: System Audit: {1.5.1} Additional Process Hardening - Ensure core dumps are restricted (Scored). File: /etc/security/limits.conf. Reference: CIS RHEL 7 Benchmark v2.2.0 .

System Audit: System Audit: {1.6.1.2} Mandatory Access Control - Ensure the SELinux state is enforcing (Scored). File: /etc/selinux/config. Reference: CIS RHEL 7 Benchmark v2.2.0 .
```
