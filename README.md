# Recap

[![Build Master Status](https://img.shields.io/travis/rackerlabs/recap/master.svg?logo=travis&label=master)](https://travis-ci.org/rackerlabs/recap)
[![Build Development Status](https://img.shields.io/travis/rackerlabs/recap/development.svg?logo=travis&label=development)](https://travis-ci.org/rackerlabs/recap)
[![GitHub release](https://img.shields.io/github/release/rackerlabs/recap.svg)](https://github.com/rackerlabs/recap/releases/latest)
[![GitHub license](https://img.shields.io/github/license/rackerlabs/recap.svg)](https://raw.githubusercontent.com/rackerlabs/recap/master/COPYING)
[![GitHub stars](https://img.shields.io/github/stars/rackerlabs/recap.svg?style=social&label=Star)](https://github.com/rackerlabs/recap)
[![Twitter](https://img.shields.io/twitter/url/https/github.com/rackerlabs/recap.svg?style=social)](https://twitter.com/intent/tweet?text=Check%20this%20out:&url=https%3A%2F%2Fgithub.com%2Frackerlabs%2Frecap)

**recap** is a system status reporting tool. A reporting script that generates reports of various information about the server.

## Contribution

Contribution guidelines can be found in [CONTRIBUTING.md](https://github.com/rackerlabs/recap/blob/master/CONTRIBUTING.md)

## Dependencies
- bash >= 4
- coreutils
- gawk
- grep
- iotop
- iproute/iproute2
- elinks
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

### Debian

Currently only available in [testing](https://packages.debian.org/source/testing/recap) and [unstable](https://packages.debian.org/source/unstable/recap). For other releases see the options to build a deb package or install from source.

The official Debian files are available in this [repository](https://github.com/jkirk/recap)

### Ubuntu

`recap` is available since [Ubuntu 19.04 (disco)](https://packages.ubuntu.com/recap).

```
apt install recap
```

You also have the option to build a deb package or install manually, see instructions down below.

### Build a deb package

This [repository](https://github.com/jkirk/recap)  contains the official Debian files required to build a deb package.

These steps used to be used to build the deb package, use them as a guide:

```bash
# Install all the packages required for building the package
apt update
apt install debhelper devscripts git -y

## For Ubuntu:
apt install equivs -y

# Create the working dir:
mkdir recap
cd recap

# Get the Debian configs
git init
git remote add origin https://github.com/jkirk/recap.git
git fetch --no-tags origin
git checkout -qf FETCH_HEAD
git submodule update --init --recursive
export LATEST=$( git log --format="%h" --no-merges -1 )

# Build dependencies
echo "yes" | mk-build-deps --install --remove debian/control

# Get upstream recap code
git checkout --orphan upstream
git reset --hard
git remote add upstream https://github.com/rackerlabs/recap.git
git fetch -t upstream
latest_tag=$( git tag | tail -1 )
git archive ${latest_tag} -o ../recap_${latest_tag}.orig.tar.gz
tar -zxf ../recap_${latest_tag}.orig.tar.gz
git fetch --no-tags origin
git checkout ${LATEST} -- debian

# Build the package
debuild -us -uc --lintian-opts --profile debian

# Package will be created in ../recap_${latest_tag}-<RELEASE>_all.deb
# RELEASE comes from the changelog in the Debian repository.
```

### Manual

1. Install the required dependencies.
2. Clone this repository: `git clone https://github.com/rackerlabs/recap.git`
3. Change into the new directory: `cd recap`
4. Install the program: `sudo make install`

The information captured will be found in log files in the `/var/log/recap/` directory.

#### About the locations of the scripts

- The default location of the install is `"/"` it can be overridden with `DESTDIR`.
- The scripts, man pages and docs are installed under "`"/usr/local"` by default, this can be overridden with `PREFIX`. Main scripts are installed on in "`./sbin`" by default, this can be overriden with `BINDIR`.
- The core scripts and the plugins are installed on top of `PREFIX` in "`./recap/plugins-available`" by default, this can be overridden with `LIBDIR`

The following example is a common location for most of the distributions, this will install `recap` under `/usr`:

  ```
$ sudo make PREFIX="/usr" install
```

This other example will install `recap` under your homedirectory but using the default locations for the script, i.e. under `"~/usr/local"`:

  ```
$ make DESTDIR="~" install
```

The `Makefile` scripts attempts to detect systemd if so, the `install` option will install the systemd unit files. The install will **not** enable the timers, but it will show the commands required to enable each of the timers.  When systemd is not detected the cronjobs will be installed.

Is up to each package distribution to follow their own best practices regarding enabling/disabling the timers on install/remove of the package.

### Ansible

An ansible playbook could be used to install `recap` from a git repository. The playbook is located in `tools` under `ansible_recap.yml` the playbook can be used to install it on Red Hat based and Debian based distros. Or to uninstall it defining the `uninstall` variable.

#### Variables

- `repo` - The location of the repository, default: `https://github.com/rackerlabs/recap.git`.
- `ref` - The reference to use this could be a branch, a tag or commit, default: `master`.
- `binpath` - The value of *BINPATH*, default: `/sbin`.
- `destdir` - The value of *DESTDIR*, default: `""`.
- `prefix` - The value of *PREFIX*, default: `/usr`.
- `tmp_install_dir` - The location where the cloned repo will be placed, default: `/tmp/recap`.
- `uninstall` - Then this is defined it will remove `recap`, default: *undefined*.
- `enable_plugins` - To enable the global plugin configuration default: `false`.
- `plugin_list` - A list of plugins to enable, from the `plugin-available` directory, default: `all`.

#### Install (default)

Install the stable version of `recap`:

```
ansible-playbook tools/ansible_recap.yml
```

Install the development version of `recap`:

```
ansible-playbook tools/ansible_recap.yml -e ref=development
```

Install branch `foo` from a different repository:

```
ansible-playbook tools/ansible_recap.yml -e ref=foo -e repo=https://github.com/bar/recap.git
```

Install recap with *BINPATH* in `/bin`:

```
ansible-playbook tools/ansible_recap.yml -e binpath=/bin

```

Install recap with all plugins enabled:

```
ansible-playbook tools/ansible_recap.yml -e enable_plugins=true

```

Install recap with a list of plugins to enable:

```
ansible-playbook tools/ansible_recap.yml \
  -e enable_plugins=true \
  -e '{"plugin_list":[docker_top,redis]}'

```

#### Uninstall

Uninstall `recap` from the default path:

```
ansible-playbook tools/ansible_recap.yml -e uninstall=yes
```

Uninstall `recap` from a custom location:

```
ansible-playbook tools/ansible_recap.yml -e uninstall=yes -e destdir=/tmp/test
```

## Cron/Timers and Configuration

### Timers(systemd)

Multiple unit files are available to make use of `timers`, here the default schedules for the recap scripts:
- recap (default every 10min)
- recap-onboot (runs at boot time)
- recaplog (default: Once a day 1am)

#### Enabling timers

Each one of the timers can be enabled with:

  ```bash
  sudo systemctl enable recap.timer --now"
  sudo systemctl enable recaplog.timer --now"
  sudo systemctl enable recap-onboot.timer --now"
  ```

#### Disabling timers

Each one of the timers can be disabled with:

  ```bash
  sudo systemctl disable recap.timer --now"
  sudo systemctl disable recaplog.timer --now"
  sudo systemctl disable recap-onboot.timer --now"
  ```

### Cron

The cron file (`/etc/cron.d/recap`) is used to determine the execution time of `recap` and `recaplog`.  By default the cron execution for `recap` is enabled to run every 10 min. and `recaplog` is expected to run every day at 1 am, but those can be adjusted as needed.

### Configuration

The following variables are commented out with the defaults values in the configuration file `/etc/recap.conf` which can be overridden.

#### Settings shared by recap scripts

- **BASEDIR** - Directory where the logs are saved.

  Default: `BASEDIR="/var/log/recap"`

- **LIBDIR** - Directory where the libraries/functions are located.

  The default value depends on the `PREFIX` used when installing, the default `PREFIX` on the `Makefile` is `/usr/local`, then:

    Default: `LIBDIR="/usr/local/lib/recap"`

  But packages use `/usr` as the `PREFIX`, then through a package it is expected to be:

    Default: `LIBDIR="/usr/lib/recap"`


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

- **USENETSTAT** - Generates network stats from "ss `${OPTS_NETSTAT}`"

  Required by: `USENETSTATSUM`

  Default: `USENETSTAT="yes"`


- **USENETSTATSUM** - Generates logs from "nstat `${OPTS_NETSTAT_SUM}`".

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

  Required by: `USEDF`, `USESLAB`, `USESAR`, `USESARQ`, `USESARR`

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

- **USESARQ** - Generates logs from "sar -q" (logs queue length, load data)

  Requires: `USERESOURCES`

  Default: `USESARQ="no"`

- **USESARR** - Generates logs from"sar -r" (logs memory data)

  Requires: `USERESOURCES`

  Default: `USESARR="no"`


#### Options

Options used by the tools generating the reports

- **DOTMYDOTCNF** - Defines the path to the mysql client configuration file

  Required by: `USEMYSQL`, `USEMYSQLPROCESSLIST`, `USEINNODB`

  Default: `DOTMYDOTCNF="/root/.my.cnf"`

- **MYSQL_PROCESS_LIST** - Format  to  display MySQL process list, options are "table" or "vertical".

  Required by: `USEMYSQLPROCESSLIST`

  Default: `MYSQL_PROCESS_LIST="table"`

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

- **OPTS_NETSTAT** - ss options

  Required by: `USENETSTAT`

  Default: `OPTS_NETSTAT="-atunp"`

- **OPTS_NETSTAT_SUM** - nstat options

  Required by: `USENETSTATSUM`

  Default: `OPTS_NETSTAT_SUM="-a"`

- **OPTS_PS** - ps options

  Required by: `USEPS`

  Default: `OPTS_PS="auxfww"`

- **OPTS_PSTREE** - pstree options

  Required by: `USEPSTREE`

  Default: `OPTS_PSTREE="-p"`


- **OPTS_VMSTAT** - vmstat options

  Required by: `USERESOURCES`

  Default: `OPTS_VMSTAT="-S M 1 3"`

## Plugins

- **USEPLUGINS** - Enable/Disable plugins usage.

  Default: `USEPLUGINS=no`

Plugins are stored in the plugin directory, defined by **LIBDIR**/plugins-available

  Default: /usr/lib/local/recap/plugin-available

### Enabling plugins

To enable plugins, the following is required to:

  - Setting `USEPLUGINS="yes"` in `/etc/recap.conf`
  - Symlinking `plugins-enabled/plugin_name` to `plugins-available/plugin_name`

### Naming conventions:

- Plugin scripts can be named in any way. It's desired that they describe the purpose of the plugin in one word. When multiple words are required use underscores (`_`). Don't use extensions or dates (e.g. `YYYYMMDD`) in the plugin name. Some examples:

  - **Good** names for plugins
    - redis
    - memcache
    - docker_images
    - memcache_13
  - **Bad** names for plugins
    - johndoe_apache   (not very descriptive)
    - myplugin         (non explicit)
    - test.sh          (non explicit, using extension)
    - recap-plugin     (non explicit, using hyphens)
    - Sendmail         (CamelCase)		
    - redis.bak        (extension)
    - ms sql           (space between words)
    - reports_20202020 (use of a date)

- Allowed naming convention for plugin **OPTIONS** in /etc/recap.conf: **PLUGIN_OPTS_<PLUGIN>_<OPT_NAME>**
  Some examples:

  - **Good** plugin option names:
    - **PLUGIN_OPTS_MEMCACHE_PROTO**
    - **PLUGIN_OPTS_AWS_KEY**
    - **PLUGIN_OPTS_REDIS_PORT**
    - **PLUGIN_OPTS_DOCKER_HUB_URL**
  - **Bad** plugin option names:
    - plugin_opts_my_plugin   (lower case)
    - PLUGIN_OPTS_MY_VARIABLE (lacking plugin reference)
    - PLUGIN_OPTS_DOCKER_port (CamelCase)
    - PLUGIN-OPTS-NTP         (using hyphens instead of underscores, missing the option)

- Inside the plugin file/script it is expected **only** functions. recap will **only** call **one** function: `print_<plugin_name>` where `plugin_name` must match the name of the file.

- Optionally, other functions can be defined to create different entries in the
  log. Those other functions could be controlled by plugin variables (**PLUGIN_OPTS_<PLUGIN>_<OPT_NAME>**). Those variables are set in `/etc/recap.conf` and conditionally called from the main plugin function `plugin_name`

- Any plugin variable defined **must** have a default value.

- The plugins are expected to follow some of the practices followed in `recap`. Please refer to [CONTRIBUTING.md](https://github.com/rackerlabs/recap/blob/master/CONTRIBUTING.md)

- A template of a plugin is provided in `doc/plugin_template`

## Changelog & Contributions

Information about changes and contributors is documented in the [CHANGELOG.md](https://github.com/rackerlabs/recap/blob/master/CHANGELOG.md)

## License

*recap* is licensed under the [GNU General Public License v2.0](https://raw.githubusercontent.com/rackerlabs/recap/master/COPYING)

