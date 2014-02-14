%define _logdir /var/log

Summary: System status reporting
Name: recap
Version: 0.9.7
Release: 0
License: GPLv2
Group: Applications/System
Vendor: Recap Team - https://github.com/rackspace/recap
Source: %{name}-%{version}.tar.gz
Distribution: RedHat
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-buildroot
Requires: sysstat, coreutils, procps, grep, gawk

%description
This program is intended to be used as a companion for the reporting provided by sysstat. It 
will create a set of reports summarizing hardware resource utilization. The script also provides
optional reporting on Apache, MySQL, and network connections.

%prep
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p -m0755 $RPM_BUILD_ROOT%{_sbindir}
mkdir -p -m0755 $RPM_BUILD_ROOT%{_datadir}/doc/recap-%{version}
mkdir -p -m0755 $RPM_BUILD_ROOT%{_sysconfdir}/cron.d
mkdir -p -m0755 $RPM_BUILD_ROOT%{_sysconfdir}/httpd/conf.d
mkdir -p -m0700 $RPM_BUILD_ROOT%{_logdir}/recap
mkdir -p -m0755 $RPM_BUILD_ROOT%{_mandir}/man5
mkdir -p -m0755 $RPM_BUILD_ROOT%{_mandir}/man8

install -m 0755 recap $RPM_BUILD_ROOT%{_sbindir}/
install -m 0755 recaptool $RPM_BUILD_ROOT%{_sbindir}/
install -m 0644 README.md $RPM_BUILD_ROOT%{_datadir}/doc/recap-%{version}/
install -m 0644 TODO $RPM_BUILD_ROOT%{_datadir}/doc/recap-%{version}/
install -m 0644 CHANGELOG $RPM_BUILD_ROOT%{_datadir}/doc/recap-%{version}/
install -m 0644 COPYING $RPM_BUILD_ROOT%{_datadir}/doc/recap-%{version}/
install -m 0644 recap.cron $RPM_BUILD_ROOT%{_sysconfdir}/cron.d/recap
install -m 0644 recap.conf $RPM_BUILD_ROOT%{_sysconfdir}/recap
install -m 0644 recap.5.gz $RPM_BUILD_ROOT%{_mandir}/man5
install -m 0644 recap.8.gz $RPM_BUILD_ROOT%{_mandir}/man8
install -m 0644 recap.conf.d $RPM_BUILD_ROOT%{_sysconfdir}/httpd/conf.d/recap

%clean
rm -rf $RPM_BUILD_ROOT

%files
%dir %{_datadir}/doc/recap-%{version}
%dir %{_logdir}/recap
%{_sbindir}/recap
%{_sbindir}/recaptool
%doc %{_datadir}/doc/recap-%{version}/README.md
%doc %{_datadir}/doc/recap-%{version}/TODO
%doc %{_datadir}/doc/recap-%{version}/CHANGELOG
%doc %{_datadir}/doc/recap-%{version}/COPYING
%config(noreplace) %{_sysconfdir}/cron.d/recap
%config(noreplace) %{_sysconfdir}/httpd/conf.d/recap
%config(noreplace) %{_sysconfdir}/recap
%doc %{_mandir}/man5/recap.5.gz
%doc %{_mandir}/man8/recap.8.gz

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
