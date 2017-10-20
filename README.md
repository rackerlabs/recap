# Recap

[![GitHub release](https://img.shields.io/github/release/rackerlabs/recap.svg)](https://github.com/rackerlabs/recap/releases/latest)
[![License](https://img.shields.io/badge/license-GPLv2-red.svg)](https://raw.githubusercontent.com/rackerlabs/recap/master/COPYING)
[![GitHub stars](https://img.shields.io/github/stars/rackerlabs/recap.svg?style=social&label=Star)](https://github.com/rackerlabs/recap)

**recap** is a system status reporting tool. A reporting script that generates reports of various information about the server.

## Contribution

Contribution guidelines can be found in [CONTRIBUTING.md](https://github.com/rackerlabs/recap/blob/master/CONTRIBUTING.md)

## Dependencies
- bash >= 4
- bc
- coreutils
- gawk
- grep
- iotop
- net-tools
- procps
- psmisc
- sysstat >= 9

## Versioning

`recap` is following the `x.y.z` versioning as defined below:

 - **x** *(major)* - Changes that prevent at least some rolling upgrades.
 - **y** *(minor)* - Changes that don't break any rolling upgrades but require closer user attention for example configuration defaults, function behavior, tools used to produce reports, among others.
 - **z** *(patch)* - Changes that are backward-compatible including features and/or bug fixes.

## Installation

It is highly recommended to make use of a package to install `recap` is the easiest way to keep it updated whenever there is a new release.

### Fedora

`recap` is available from the main Fedora repository ([spec file](https://src.fedoraproject.org/rpms/recap/blob/master/f/recap.spec)).

```
dnf install recap
```

### RHEL/CentOS

`recap` is available from the [EPEL](https://fedoraproject.org/wiki/EPEL) repository ([spec file](https://src.fedoraproject.org/rpms/recap/blob/master/f/recap.spec)).

```
yum install recap
```

### Ubuntu

At the moment there is no public repository for Ubuntu, use the [manual installation](#manual) method.

### Debian

At the moment there is no public repository for Debian, use the [manual installation](#manual) method.

### Manual

1. Install the required dependencies.
2. Clone this repository: `git clone https://github.com/rackerlabs/recap.git`
3. Change into the new directory: `cd recap`
4. Install the program: `sudo make install`

The information captured will be found in log files in the `/var/log/recap/` directory.

#### About the locations of the scripts

The default location of the install is `"/"` it can be overriden with `DESTDIR`, the scripts, man pages and docs are installed under "`"/usr/local"` by default, this can be overriden with `PREFIX`. The following example is a common location for most of the distributions, this will install `recap` under `/usr`:

  ```
$ sudo make PREFIX="/usr" install 
```

This other example will install `recap` under your homedirectory but using the default locations for the script, i.e. under `"~./usr/local"`:

  ```
$ make DESTDIR="~" install
```

## Cron and Configuration

### Cron

The cron file (`/etc/cron.d/recap`) is used to determine the execution time of `recap` and `recaplog`.  By default the cron execution for `recap` is enabled to run every 10 min. and `recaplog` is expected to run every day at 1 am, but those can be adjusted as needed.

### Configuration

The following variables are commented out with the defaults values in the configuration file `/etc/recap` which can be overriden.

#### Settings shared by recap scripts

- **BASEDIR** - Directory where the logs are saved.

  Default: `BASEDIR="/var/log/recap"`

- **BACKUP_ITEMS** - Is the list of reports generated and used by recap scripts

  Default: `BACKUP_ITEMS="fdisk mysql netstat ps pstree resources"`


#### Settings used only by `recaplog`

- **LOG_COMPRESS** - Enable or disable log compression.

  Default: `LOG_COMPRESS=1`

- **LOG_EXPIRY** - Log files will be deleted after LOG_EXPIRY days

  Default: `LOG_EXPIRY=15`

#### Settings used only by `recap`

- **MAILTO** - Send a report to the email defined.

  Default: `MAILTO=""`

- **MIN_FREE_SPACE** - Minimum free space (in MB) required in `${BASEDIR}` to run recap, a value of 0 deactivates this check.

  Default: `MIN_FREE_SPACE=0`

- **MAXLOAD** - Maximum load allowed to run recap, abort if load is higher than this value.

  Default: `MAXLOAD=10`


#### Reports

These are the type of reports generated and their dependencies.

##### fdisk

- **USEFDISK** - Generates logs from "fdisk `${OPTS_FDISK}`"

  Default: `USEFDISK="no"`

##### mysql

- **USEMYSQL** - Generates logs from "mysqladmin status"

  Makes use of `DOTMYDOTCNF`.

  Required by: `USEMYSQLPROCESSLIST`, `USEINNODB`

  Default: `USEMYSQL="no"`

- **USEMYSQLPROCESSLIST** - Generates logs from "mysqladmin processlist"

  Makes use of `DOTMYDOTCNF` and `MYSQL_PROCESS_LIST`

  Requires: `USEMYSQL`

  Default: `USEMYSQLPROCESSLIST="no"`

- **USEINNODB** - Generates logs from "mysql show engine innodb status"

  Makes use of `DOTMYDOTCNF`

  Requires: `USEMYSQL`

  Default: `USEINNODB="no"`


##### netstat

- **USENETSTAT** - Generates network stats from "netstat `${OPTS_NETSTAT}`"

  Required by: `USENETSTATSUM`

  Default: `USENETSTAT="yes"`


- **USENETSTATSUM** - Generates logs from "netstat `${OPTS_NETSTAT_SUM}`".

  Requires: `USENETSTAT`

  Default: `USENETSTATSUM="no"`

##### ps

- **USEPS** - Generates logs from "ps"

  Options can be modified in `OTPS_PS`

  Default: `USEPS="yes"`

##### pstree

- **USEPSTREE** - Generates logs from pstree

  Options can be modified in `OTPS_PSTREE`

  Default: `USEPSTREE="no"`

##### resources

- **USERESOURCES** - Generates "resources"(uptime, free, vmstat, iostat, iotop) log

  Required by: `USEDF`, `USESLAB`, `USESAR`, `USESARQ`, `USESARR`, `USEFULLSTATUS`

  Default: `USERESOURCES="yes"`


- **USEDF** - Generates logs from df

  Requires: `USERESOURCES`

  Options can be modified in `OPTS_DF`

  Default: `USEDF="yes"`

- **USESLAB** - Generates logs from the slab table.

  Requires: `USERESOURCES`

  Default: `USESLAB="no"`


- **USERSAR** - Generates logs from sar.

  Requires: `USERESOURCES`

  Default: `USESAR="yes"`

- **USESARQ** - Generates logs from "sar -q" (logs queue lenght, load data)

  Requires: `USERESOURCES`

  Default: `USESARQ="no"`

- **USESARR** - Generates logs from"sar -r" (logs memory data)

  Requires: `USERESOURCES`

  Default: `USESARR="no"`

- **USEFULLSTATUS** - Performs an http request(GET) to the URL defined in `OPTS_STATUSURL`. Needs a webserver configured to respond to this request. Nginx(nginx_status) and Apache HTTPD(server-stats) offer this functionality that needs to be enabled.

  Requires: `USERESOURCES`

  Default: `USEFULLSTATUS="no"`


#### Options

Options used by the tools generating the reports

- **DOTMYDOTCNF** - Defines the path to the mysql client configuration file

  Required by: `USEMYSQL`, `USEMYSQLPROCESSLIST`, `USEINNODB`

  Default: `DOTMYDOTCNF="/root/.my.cnf"`

- **MYSQL_PROCESS_LIST** - Format  to  display MySQL process list, options are "table" or "vertical".

  Required by: `USEMYSQLPROCESSLIST`

  Default: `MYSQL_PROCESS_LIST="table"`

- **OPTS_LINKS** - Options used by links.
  Required by: `USEFULLSTATUS`

  Default: `OPTS_LINKS="-dump"`

- **OPTS_DF** - df options

  Required by: `USEDF`

  Default: `OPTS_DF="-x nfs"`

- **OPTS_FDISK** - Option used by USEFDISK.

  Required by: `USEFDISK`

  Default: `OPTS_FDISK="-l"`

- **OPTS_FREE** - free options

  Required by: `USEFREE`

  Default: `OPTS_FREE=""`

- **OPTS_IOSTAT** - iostat options

  Required by: `USERESOURCES`

  Default: `OPTS_IOSTAT="-t -x 1 3"`

- **OPTS_IOTOP** - iotop options

  Required by: `USERESOURCES`

  Default: `OPTS_IOTOP="-b -o -t -n 3"`

- **OPTS_NETSTAT** - netstat options

  Required by: `USENETSTAT`

  Default: `OPTS_NETSTAT="-ntulpae"`

- **OPTS_NETSTAT_SUM** - netstat statistics options

  Required by: `USENETSTATSUM`

  Default: `OPTS_NETSTAT_SUM="-s"`

- **OPTS_PS** - ps options

  Required by: `USEPS`

  Default: `OPTS_PS="auxfww"`

- **OPTS_PSTREE** - pstree options

  Required by: `USEPSTREE`

  Default: `OPTS_PSTREE="-p"`


- **OPTS_STATUSURL** - URL to perform the http request  when USEFULLSTATUS is enabled.

  Required by: `USEFULLSTATUS`

  Default: `OPTS_STATUSURL="http://localhost:80/server-status"`

- **OPTS_VMSTAT** - vmstat options

  Required by: `USERESOURCES`

  Default: `OPTS_VMSTAT="-S M 1 3"`

## Changelog & Contributions

Information about changes and contributors is documented in the [CHANGELOG.md](https://github.com/rackerlabs/recap/blob/master/CHANGELOG.md)

## License

*recap* is licensed under the [GNU General Public License v2.0](https://raw.githubusercontent.com/rackerlabs/recap/master/COPYING)

