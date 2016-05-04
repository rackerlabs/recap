DESTDIR ?= /
SBINDIR = $(DESTDIR)/usr/sbin
SYSCONFDIR = $(DESTDIR)/etc
MANDIR = $(DESTDIR)/usr/share/man
LOGDIR = $(DESTDIR)/var/log/recap
CRONDIR = $(DESTDIR)/etc/cron.d

all:
	@echo "Nothing to compile, run make install."

install:
	@echo "Installing scripts..."
	@install -Dm0755 src/recap $(SBINDIR)/recap
	@install -Dm0755 src/recaplog $(SBINDIR)/recaplog
	@install -Dm0755 src/recaptool $(SBINDIR)/recaptool
	@echo "Installing man pages..."
	@install -Dm0644 src/recap.5 $(MANDIR)/man5/recap.5
	@install -Dm0644 src/recap.8 $(MANDIR)/man8/recap.8
	@install -Dm0644 src/recaplog.8 $(MANDIR)/man8/recaplog.8
	@echo "Installing configuration..."
	@install -Dm0644 src/recap.conf $(SYSCONFDIR)/recap
	@echo "Installing cron job..."
	@install -Dm0644 src/recap.cron $(CRONDIR)/recap
	@echo "Creating log directories..."
	@install -dm0750 $(LOGDIR)
	@install -dm0750 $(LOGDIR)/backups
	@install -dm0750 $(LOGDIR)/snapshots

uninstall:
	@echo "Removing scripts..."
	@rm -f $(SBINDIR)/recap
	@rm -f $(SBINDIR)/recaplog
	@rm -f $(SBINDIR)/recaptool
	@echo "Removing man pages..."
	@rm -f $(MANDIR)/man5/recap.5
	@rm -f $(MANDIR)/man8/recap.8
	@rm -f $(MANDIR)/man8/recaplog.8
	@echo "Removing configuration..."
	@rm -f $(SYSCONFDIR)/recap
	@echo "Removing cron job..."
	@rm -f $(CRONDIR)/recap

.PHONY: install uninstall purge
