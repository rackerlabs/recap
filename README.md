# Recap
# stuff

recap is a reporting script that generates reports of 
various information about the server.

## Dependencies
* git - Installation
* bc - arithmetic calculations
* elinks (or another cli web browser) - apache fullstatus
* net-tools - netstat report
* sysstat - provides 'iostat' for  I/O statistics
* iotop - simple top-like I/O monitor

## Installation
1. Install the required dependencies:
  * Debian/Ubuntu - `apt-get install git bc elinks net-tools sysstat iotop`
  * RHEL/CentOS - `yum install git bc elinks net-tools sysstat iotop`
2. Clone this repository: `git clone https://github.com/rackerlabs/recap.git`
3. Change into the new directory: `cd recap`
4. Install the program: `make install`

The information captured will be found in log files in the `/var/log/recap/` directory.

## Configuration

The cron file (`/etc/cron.d/recap`) is used to determine the execution time of
`recap` and `recaplog`.  By default the cron execution for `recap` is enabled
to run every 10 min. and `recaplog` is expected to run
every day at 1 am, but those can be adjusted as needed.

The following variables are defined with defaults inside the 
script but can be overwritten if these variables are defined
in /etc/recap

```
DATE=`date +%Y-%m-%d_%H:%M:%S
ROTATE="7"
```

`DATE` is the format of the date header at the top of the reports/email

`ROTATE` is the number of files to maintain for rotation purposes

Additional optional variables are as follows:

`MAILTO` i.e., `MAILTO="username@example.com"`

`USEPS` do you want to generate the ps.log? (no/yes) default yes

`USERESOURCES` do you want to generate the resources.log? (no/yes) default yes

`USESAR` do you want to generate sar reports? (no/yes) default no

`USESARR` do you want to generate sar -r reports? (no/yes) default no

`USESARQ` do you want to generate sar -q reports? (no/yes) default no

`USEFULLSTATUS` do you want to generate "service httpd fullstatus" reports? (no/yes) default no

See the recap man pages for additional optional reports. Some reports depend on 
parent reports to generate the file they will write their output to. 

For instance, the `USESAR` reports above all rely on having `USERESOURCES` enabled.

The script will never need to be modified for these variables, they
can all be defined in `/etc/recap`

If you want a backup of the last file created before a reboot
uncomment the `@reboot` line in the crontab file `/etc/cron.d/recap`

Uncomment the lines to enable the backup

## Info & License
```
Package name:   recap
Author:         The Common Public
Maintainers:    Brent Oswald, Benjamin Graham, Simone Soldateschi
License:        GPL 2.0
Homepage:       https://github.com/rackerlabs/recap/

Original authors at Rackspace (http://www.rackspace.com):
                    -Jacob Walcik
                    -Carl Thompson

Past contributors at Rackspace:
                    -David King
                    -Hans duPlooy
                    -All other should be defined in CHANGELOG.md
```
