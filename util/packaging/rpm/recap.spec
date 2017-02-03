Name: recap
Version: 0.9.14
Release: 1.rs%{?dist}
Summary: System status reporting
Group: Applications/System
License: GPLv2
Url: https://github.com/rackerlabs/%{name}
Source0: https://github.com/rackerlabs/%{name}/archive/%{version}.tar.gz
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
Requires: sysstat, coreutils, procps, grep, gawk, bc, elinks, net-tools, iotop
Obsoletes: rs-sysmon < 0.9.5-2
Provides: rs-sysmon = %{version}-%{release}


%description
This program is intended to be used as a companion for the reporting provided by sysstat. It 
will create a set of reports summarizing hardware resource utilization. The script also provides
optional reporting on Apache, MySQL, and network connections.


%prep
%setup -q


%install
%{__rm} -rf %{buildroot}
DESTDIR=%{buildroot} make install


%clean
%{__rm} -rf %{buildroot}


%files
%{!?_licensedir:%global license %%doc}
%license COPYING
%doc README.md TODO CHANGELOG
%dir %{_localstatedir}/log/recap
%dir %{_localstatedir}/log/recap/backups
%dir %{_localstatedir}/log/recap/snapshots
%{_sbindir}/recap
%{_sbindir}/recaplog
%{_sbindir}/recaptool
%config(noreplace) %{_sysconfdir}/cron.d/recap
%config(noreplace) %{_sysconfdir}/recap
%{_mandir}/man5/recap.5.gz
%{_mandir}/man8/recap.8.gz
%{_mandir}/man8/recaplog.8.gz


%changelog
* Wed May 11 2016 Ben Harper <ben.harper@rackspace.com> - 0.9.14-1.rs
- Latest version
- Fixing typos, removing commented old code, renaming functions

* Wed May 04 2016 Carl George <carl.george@rackspace.com> - 0.9.13-1.rs
- Latest version
- Install recaplog man page

* Fri Apr 22 2016 Carl George <carl.george@rackspace.com> - 0.9.12-1.rs
- Latest version
- Use Makefile to install

* Tue Apr 12 2016 Carl George <carl.george@rackspace.com> - 0.9.11-3.rs
- Add missing recaplog file
- Use appropriate license directory when possible
- Remove httpd example configuration

* Mon Apr 11 2016 Carl George <carl.george@rackspace.com> - 0.9.11-2.rs
- Add rs to release

* Wed Jan 06 2016 Carl George <carl.george@rackspace.com> - 0.9.11-1
- Latest version

* Mon Dec 21 2015 Carl George <carl.george@rackspace.com> - 0.9.10-1
- Latest version
- Update dependencies

* Fri Jun 12 2015 Carl George <carl.george@rackspace.com> - 0.9.8-2
- Fix EL5 COPR build

* Wed Jan 07 2015 Carl George <carl.george@rackspace.com> - 0.9.8-1
- Latest version

* Thu Nov 1 2012 Benjamin H. Graham <ben@administr8.me>
-First public release GPLv2, special thanks to Rackspace IPC, Brent Oswald, and Benjamin H. Graham
-Changed name to recap, added links for new repository
-Added recaptool and installer

* Tue Nov 16 2010 Jacob Walcik <jacob.walcik@rackspce.com>
-Added COPYING file to specify license as GPL
-Added full list of dependencies for basic reporting
-Updated description

* Thu May 27 2010 David King <david.king@rackspace.com>
-Changed version number of recap release and added a configuration file for apache to access recap logs

* Tue Oct 20 2009 David King <david.king@rackspace.com>
-Changed /etc/cron.d/recap and /etc/recap to be config noreplace files

* Thu Nov 13 2008 Jacob Walcik <jacob.walcik@rackspace.com>
-modified default mode of the output directory

* Thu Nov 01 2007 Carl Thompson <carl.thompson@rackspace.com>
-added support for service httpd fullstatus by Jacob Walcik <jacob.walcik@rackspace.com>

* Wed Sep 12 2007 Carl Thompson <carl.thompson@rackspace.com>
-added man pages created by Jacob Walcik <jacob.walcik@rackspace.com>

* Thu Jul 12 2007 Carl Thompson <carl.thompson@rackspace.com>
-Added pstree support

* Tue Jul 10 2007 Carl Thompson <carl.thompson@rackspace.com>
-Fixed permissions on cron file, added 2 cron tasks for @reboot in cron file

* Tue Jul 10 2007 Carl Thompson <carl.thompson@rackspace.com>
-Added sar -q and inline documentation, relocated doc to recap-version

* Mon Jul 09 2007 Carl Thompson <carl.thompson@rackspace.com>
-Initial build of package
