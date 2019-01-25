#   Copyright (C) 2017 Rackspace, Inc.
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with this program; if not, write to the Free Software Foundation, Inc.,
#   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


DESTDIR       ?=
BINPATH       ?= /sbin
PREFIX        ?= /usr/local
BINDIR        ?= $(PREFIX)$(BINPATH)
LIBDIR        ?= $(PREFIX)/lib
MANDIR        ?= $(PREFIX)/share/man
DOCDIR        ?= $(PREFIX)/share/doc
SYSCONFDIR    ?= /etc
CRONDIR       ?= $(SYSCONFDIR)/cron.d
SYSTEMDDIR    ?= /usr/lib/systemd/system
LOGDIR        ?= /var/log

ifneq ("$(wildcard /bin/systemctl)","")
	type=systemd
else
	type=cron
endif

all:
	@echo "Nothing to compile, please choose a specific target:"
	@echo "    install (includes install-base, install-man, install-doc and install-(cron/systemd)*)"
	@echo "    install-base"
	@echo "    install-cron"
	@echo "    install-systemd"
	@echo "    install-man"
	@echo "    install-doc"
	@echo "    uninstall (includes uninstall-base, uninstall-man, uninstall-doc and uninstall-(cron/systemd)*)"
	@echo "    uninstall-base"
	@echo "    uninstall-cron"
	@echo "    uninstall-systemd"
	@echo "    uninstall-man"
	@echo "    uninstall-doc"
	@echo ""
	@echo "*If systemd is available it will (un)install systemd units instead of cron"
	@echo "Current type detected is: $(type)"

recap.cron:
	@sed -e 's|^\s*\(BINDIR=\).*$$|\1$(BINDIR)|' src/utils/recap.cron.in > src/utils/recap.cron

recap.systemd:
	@for service_file in src/utils/*.service.in; do \
	sed -e 's|^\s*\(Environment=BINDIR=\).*$$|\1$(BINDIR)|' $${service_file} > $${service_file%.in}; \
	done

clean:
	@rm -f src/utils/recap.cron
	@rm -f src/utils/*.service

install: install-base install-man install-doc install-$(type)

uninstall: uninstall-base uninstall-man uninstall-doc uninstall-$(type)

install-base:
	@echo "Installing scripts..."
	@sed -i.orig 's|^\s*\(declare\s\+-r\s\+LIBDIR=\).*$$|\1"$(LIBDIR)/recap"|' src/recap
	@install -Dm0755 src/recap $(DESTDIR)$(BINDIR)/recap
	@install -Dm0755 src/recaplog $(DESTDIR)$(BINDIR)/recaplog
	@install -Dm0755 src/recaptool $(DESTDIR)$(BINDIR)/recaptool
	@mv -f src/recap.orig src/recap
	@echo "Installing libraries..."
	@install -dm0755 $(DESTDIR)$(LIBDIR)/recap
	@install -dm0755 $(DESTDIR)$(LIBDIR)/recap/core
	@install -dm0755 $(DESTDIR)$(LIBDIR)/recap/plugins-available
	@install -dm0755 $(DESTDIR)$(LIBDIR)/recap/plugins-enabled
	@install -Dm0644 src/core/* $(DESTDIR)$(LIBDIR)/recap/core/
	@install -Dm0644 src/plugins/* $(DESTDIR)$(LIBDIR)/recap/plugins-available/
	@echo "Installing configuration..."
	@install -Dm0644 src/recap.conf $(DESTDIR)$(SYSCONFDIR)/recap.conf
	@echo "Creating log directories..."
	@install -dm0750 $(DESTDIR)$(LOGDIR)/recap
	@install -dm0755 $(DESTDIR)$(LOGDIR)/recap/backups
	@install -dm0755 $(DESTDIR)$(LOGDIR)/recap/snapshots

install-cron: recap.cron
	@echo "Installing cron job..."
	@install -Dm0644 src/utils/recap.cron $(DESTDIR)$(CRONDIR)/recap

install-systemd: recap.systemd
	@echo "Installing systemd timers and services..."
	@install -dm0755 $(DESTDIR)$(SYSTEMDDIR)
	@install -Dm0644 src/utils/*.service $(DESTDIR)$(SYSTEMDDIR)/
	@install -Dm0644 src/utils/*.timer $(DESTDIR)$(SYSTEMDDIR)/
	@echo "Use the following to enable the systemd timers:"
	@echo "sudo systemctl enable recap.timer --now"
	@echo "sudo systemctl enable recaplog.timer --now"
	@echo "sudo systemctl enable recap-onboot.timer --now"

install-man:
	@echo "Installing man pages..."
	@install -Dm0644 src/recap.conf.5 $(DESTDIR)$(MANDIR)/man5/recap.conf.5
	@install -Dm0644 src/recap.8 $(DESTDIR)$(MANDIR)/man8/recap.8
	@install -Dm0644 src/recaplog.8 $(DESTDIR)$(MANDIR)/man8/recaplog.8
	@install -Dm0644 src/recaptool.8 $(DESTDIR)$(MANDIR)/man8/recaptool.8

install-doc:
	@echo "Installing docs..."
	@install -dm0755 $(DESTDIR)$(DOCDIR)/recap
	@install -Dm0644 CHANGELOG.md README.md COPYING -t $(DESTDIR)$(DOCDIR)/recap

uninstall-base:
	@echo "Removing scripts..."
	@rm -f $(DESTDIR)$(BINDIR)/recap
	@rm -f $(DESTDIR)$(BINDIR)/recaplog
	@rm -f $(DESTDIR)$(BINDIR)/recaptool
	@echo "Removing libraries..."
	@rm -Rf $(DESTDIR)$(LIBDIR)/recap/core
	@rm -Rf $(DESTDIR)$(LIBDIR)/recap/plugins-available
	@rm -Rf $(DESTDIR)$(LIBDIR)/recap/plugins-enabled
	@echo "Removing configuration..."
	@rm -f $(DESTDIR)$(SYSCONFDIR)/recap

uninstall-cron:
	@echo "Removing cron job..."
	@rm -f $(DESTDIR)$(CRONDIR)/recap

uninstall-systemd:
	@echo "Removing systemd timers and services..."
	@rm -f $(DESTDIR)$(SYSTEMDDIR)/recap*.{service,timer}
	@echo "Use the following to disable the systemd timers:"
	@echo "sudo systemctl disable recap.timer --now"
	@echo "sudo systemctl disable recaplog.timer --now"
	@echo "sudo systemctl disable recap-onboot.timer --now"

uninstall-man:
	@echo "Removing man pages..."
	@rm -f $(DESTDIR)$(MANDIR)/man5/recap.conf.5
	@rm -f $(DESTDIR)$(MANDIR)/man8/recap.8
	@rm -f $(DESTDIR)$(MANDIR)/man8/recaplog.8
	@rm -f $(DESTDIR)$(MANDIR)/man8/recaptool.8

uninstall-doc:
	@echo "Removing docs..."
	@rm -Rf $(DESTDIR)$(DOCDIR)/recap

.PHONY: install install-base install-cron install-systemd install-man install-doc uninstall uninstall-base uninstall-cron uninstall-systemd uninstall-man uninstall-doc clean
