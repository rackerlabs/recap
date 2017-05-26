# Change Log
All notable changes to this project will be documented in this file.

## [1.0.0] - 2017-05-15
- Record point-in-time CPU.
- Multiple bug fixing on recaptool.
- Multiple bug fixing on recap.
- Refactor of recaplog.
- Fix plesk mysql bug.
- Install recaptool man page.
- Adding specific requirements for bash(>=4) and sysstat(>=9).
- Removing rpm spec requirements: elinks.
- Obsoletes and provides rs-sysmon.
- Better support for multiple mysql instances.
- Makefile updated to allow multiple distros alignment and to include new man pages.
- Adjust spec for Makefile.
- Makefile now uses /usr/local as default for DESTDIR.
- fdisk warnings(stderr) are now included in the logs(stdin).

## [0.9.14] - 2016-05-11
- Fix #55 Code clean up, typos fixed and functions renamed

## [0.9.13] - 2016-05-04
- Fix #52 recaptool globbing
- Fix #54 install recaplog man page

## [0.9.12] - 2016-04-22
- Fix #41 (add sysstat and iotop to dependencies)
- Fix #49 (reorg and Makefile)
- Fix #51 (typo on recaptool suffix path on log files)

## [0.9.11] - 2015-12-23
- updates to handling multiple DOTMYDOTCNF logic

## [0.9.10] - 2015-12-21
- Adjusted Default MAXLOAD value
- Fixed #27 (Document MAXLOAD)

## [0.9.9-development] - 2015-01-31
- Fix #17 by merging plesk check into print_mysql_procs and print_mysql
- Created branch for development and tags for stable and development versions

## [0.9.8] - 2015-01-07
- Fix #12 (custom .my.cnf, multi-mysql support)
- Fix #13 (log files not being copied to /var/log/recap/backups)
- Fix #15/22 (ensure apachectl and mysqladmin are available)

## [0.9.7] - 2013-10-31
- command line options can be specified in 'Configuration stanza'
- timestamp is appended to log filenames
- implemented log rotation (see: 'recaplog', rotated log files can be Gzip'd)

## [0.9.6] - 2012-11-01
- First public release GPLv2, special thanks to Rackspace IPC, Brent Oswald, and Benjamin H. Graham
- Changed name to recap, added links for new repository
- Integrated recaptool
- Added simple installer - (tested on debian)
- Added MacOSX support to installer

## [0.9.5] - 2012-11-01
- First release under GPL

## [0.9.4] - 2012-11-01
- Modified output of MySQL report to include full query output
- Corrected output of iostat

## [0.9.3-2] - 2012-11-01
- Changed default mode on /var/log/rs-sysmon from 750 to 700
- Corrected @reboot cron job (was missing the user name)

## [0.9.3] - 2012-11-01
- All reports are now optional (configurable in /etc/rs-sysmon)
- Modified backup functionality so that backups are only generated for reports that are currently configured to run (won't create backups for stale files)

## [0.9.2] - 2012-11-01
- Consolidated function calls to generate reports. Calls to generate individual reports are now encapsulated into one wrapper function per report
- Code clean-up to standardize style throughout script
- Added more explicit handling for invalid user input (multiple flags, invalid flags)
- Changed the default mode on the output directory to 750 (no longer world readable)
- Laid the groundwork for making all reports optional
- Updated backup and snapshot functionality to better handle optional reports
- Moved the standard location for the configuration file to /etc/sysconfig
- Updated man pages to reflect changes

## [0.9.1] - 2012-11-01
- Added check to ensure that the script is running as root
- Moved check for output directory so that it takes place after CLI flags have been interpreted 

## [0.9] - 2012-11-01
- Consolidated bash functions
- Consolidated output directories
- Updated spec file to automate consolidation of log files on install
- Removed documented options for changing output directories 
- Added optional reports for network connections and MySQL status

## [0.8-2] - 2012-11-01
- Modified the call to mktemp so that it uses a template. This is to improve compatibility with RHEL 2.1

## [0.8] - 2012-11-01
- Modified the send_mail function so that it generates a random tmp directory to use rather than always writing to the same location

## [0.7] - 2012-11-01
- Added flag to perform snapshots. A snapshot is a one-time report that generates time-stamped output files. These files are not included in the output file rotation
- Added flag to perform a backup of the latest reports. There was an issue on some servers where the second "@reboot" command would not be executed from cron. This creates a time-stamped copy (similar to the snapshots above, but labeled "backup") of the latest set of report files
- Wrapped almost all functionality in bash functions to allow for more flexible execution of rs-sysmon functionality. This is still a mess and will continue to be addressed in future releases.

---

# Contributors
- Alan Pearce
- Ben Harper (b-harper)
- Benjamin H. Graham (bhgraham)
- Blake Moore
- Brandon Tomlinson (thebwt)
- Brent A. Oswald (buzzboy23)
- Carl George (cgtx)
- Christian (thtieig)
- Cian Brennan (lil-cain)
- Erik Ljungstrom
- James Belchamber
- Sean Dennis (jamrok)
- Jay Goldberg
- Jeffrey Ness
- John Schwinghammer (schwing)
- LukeHandle
- Man Chung (man-chung)
- Piers Cornwell (piersc)
- rackerjimmy
- Ryan Stark (ryansyah)
- Sammy Larbi (codeodor)
- Sean Roberts (seanorama)
- Simone Soldateschi (siso)
- Tony Garcia (tonyskapunk)

