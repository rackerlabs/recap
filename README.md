Recap:

#
#   Package name:   recap
#   Author:         Jacob Walcik
#                   Carl Thompson
#                   David King
#
#   Maintainer:     Brent Oswald
#                   Benjamin Graham
#
#   License:        GPL 2.0
#
#   Homepage:       https://github.com/rackspace/recap/
#

recap is a reporting script that generates reports of 
various information about the server.

The cron file (/etc/cron.d/recap) is used to determine
the execution time of recap.  By default the cron execution
of the program is not enabled.

The following variables are defined with defaults inside the 
script but can be overwritten if these variables are defined
in /etc/recap

DATE=`date +%Y-%m-%d_%H:%M:%S`
ROTATE="7"

DATE is the format of the date header at the top of the reports/email

ROTATE is the number of files to maintain for rotation purposes

Additional optional variables are as follows:

MAILTO

ie:  MAILTO="username@domain.com"

USEPS do you want to generate the ps.log? (no/yes) default yes

USERESOURCES do you want to generate the resources.log? (no/yes) default yes

USESAR do you want to generate sar reports? (no/yes) default no

USESARR do you want to generate sar -r reports? (no/yes) default no

USESARQ do you want to generate sar -q reports? (no/yes) default no

USEFULLSTATUS do you want to generate "service httpd fullstatus" reports? (no/yes) default no

See the recap man pages for additional optional reports. Some reports depend on 
parent reports to generate the file they will write their output to. 

For
instance, the USESAR reports above all rely on having USERESOURCES enabled.

The script will never need to be modified for these variables, they
can all be defined in /etc/recap

If you want a backup of the last file created before a reboot
uncomment the @reboot line in the crontab file /etc/cron.d/recap

Uncomment the lines to enable the backup
