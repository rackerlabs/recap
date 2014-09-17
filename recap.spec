%define _logdir /var/log

Summary: System status reporting
Name: recap
Version: 0.9.7
Release: 0
License: GPLv2
Group: Applications/System
Vendor: Recap Team - https://github.com/rackerlabs/recap
Source: %{name}-%{version}.tar.gz
Distribution: RedHat
BuildArch: noarch
%{?el5:BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)}
Requires: sysstat, coreutils, procps, grep, gawk


%description
This program is intended to be used as a companion for the reporting provided by sysstat. It 
will create a set of reports summarizing hardware resource utilization. The script also provides
optional reporting on Apache, MySQL, and network connections.


%prep
%setup -q


%install
%{?el5:%{__rm} -rf %{buildroot}}
%{__install} -Dm0755 recap %{buildroot}%{_sbindir}/recap
%{__install} -Dm0755 recaptool %{buildroot}%{_sbindir}/recaptool
%{__install} -Dm0644 recap.conf %{buildroot}%{_sysconfdir}/recap
%{__install} -Dm0644 recap.cron %{buildroot}%{_sysconfdir}/cron.d/recap
%{__install} -Dm0644 recap.conf.d %{buildroot}%{_sysconfdir}/httpd/conf.d/recap
%{__install} -Dm0644 recap.5.gz %{buildroot}%{_mandir}/man5/recap.5.gz
%{__install} -Dm0644 recap.8.gz %{buildroot}%{_mandir}/man8/recap.8.gz
%{__install} -dm0700 %{buildroot}%{_logdir}/recap


%{?el5:%clean}
%{?el5:%{__rm} -rf %{buildroot}}


%files
%doc README.md TODO CHANGELOG COPYING
%dir %{_logdir}/recap
%{_sbindir}/recap
%{_sbindir}/recaptool
%config(noreplace) %{_sysconfdir}/cron.d/recap
%config(noreplace) %{_sysconfdir}/httpd/conf.d/recap
%config(noreplace) %{_sysconfdir}/recap
%{_mandir}/man5/recap.5.gz
%{_mandir}/man8/recap.8.gz


%post
if [ -f /etc/rs-sysmon ]; then
        echo "Found configuration file in old location (/etc/rs-sysmon), moving it to the new location (/etc/recap)."
        mv /etc/recap /etc/recap.orig
        mv /etc/rs-sysmon /etc/recap
fi
echo
echo "Checking for output directories..."

if [ -d /var/log/rs-sysmon ]; then
        echo
        echo "Found old output directory: /var/log/rs-sysmon"
        echo "Moving resources logs to /var/log/recap"
        mv /var/log/rs-sysmon/* /var/log/recap
        echo "Removing old output directory: /var/log/rs-sysmon"
        rm -r /var/log/rs-sysmon
        echo
        echo "Your output files have been consolidated to /var/log/recap, and the old output directories have been removed. If you see any errors above, there may have been some unexpected files that prevented the old directories from being emptied."
fi
echo
echo "The cron execution of recap is set to run every 10 minutes and at reboot by default."
echo "Edit /etc/cron.d/recap to change cron execution."


%changelog
*Thu Nov 1 2012 Benjamin H. Graham <ben@administr8.me>
-First public release GPLv2, special thanks to Rackspace IPC, Brent Oswald, and Benjamin H. Graham
-Changed name to recap, added links for new repository
-Added recaptool and installer

*Tue Nov 16 2010 Jacob Walcik <jacob.walcik@rackspce.com>
-Added COPYING file to specify license as GPL
-Added full list of dependencies for basic reporting
-Updated description

*Thu May 27 2010 David King <david.king@rackspace.com>
-Changed version number of recap release and added a configuration file for apache to access recap logs

*Tue Oct 20 2009 David King <david.king@rackspace.com>
-Changed /etc/cron.d/recap and /etc/recap to be config noreplace files

*Thu Nov 13 2008 Jacob Walcik <jacob.walcik@rackspace.com>
-modified default mode of the output directory

*Thu Nov 01 2007 Carl Thompson <carl.thompson@rackspace.com>
-added support for service httpd fullstatus by Jacob Walcik <jacob.walcik@rackspace.com>

*Wed Sep 12 2007 Carl Thompson <carl.thompson@rackspace.com>
-added man pages created by Jacob Walcik <jacob.walcik@rackspace.com>

*Thu Jul 12 2007 Carl Thompson <carl.thompson@rackspace.com>
-Added pstree support

*Tue Jul 10 2007 Carl Thompson <carl.thompson@rackspace.com>
-Fixed permissions on cron file, added 2 cron tasks for @reboot in cron file

*Tue Jul 10 2007 Carl Thompson <carl.thompson@rackspace.com>
-Added sar -q and inline documentation, relocated doc to recap-version

*Mon Jul 09 2007 Carl Thompson <carl.thompson@rackspace.com>
-Initial build of package
