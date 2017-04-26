DESTDIR       ?=
BINPATH       ?= /sbin
PREFIX        ?= /usr/local
BINDIR        ?= $(PREFIX)$(BINPATH)
MANDIR        ?= $(PREFIX)/share/man
DOCDIR        ?= $(PREFIX)/share/doc
SYSCONFDIR    ?= /etc
CRONDIR       ?= $(SYSCONFDIR)/cron.d
LOGDIR        ?= /var/log

all:
	@echo "Nothing to compile, run make install."

install:
	@echo "Installing scripts..."
	@install -Dm0755 src/recap $(DESTDIR)$(BINDIR)/recap
	@install -Dm0755 src/recaplog $(DESTDIR)$(BINDIR)/recaplog
	@install -Dm0755 src/recaptool $(DESTDIR)$(BINDIR)/recaptool
	@echo "Installing man pages..."
	@install -Dm0644 src/recap.5 $(DESTDIR)$(MANDIR)/man5/recap.5
	@install -Dm0644 src/recap.8 $(DESTDIR)$(MANDIR)/man8/recap.8
	@install -Dm0644 src/recaplog.8 $(DESTDIR)$(MANDIR)/man8/recaplog.8
	@install -Dm0644 src/recaptool.8 $(DESTDIR)$(MANDIR)/man8/recaptool.8
	@echo "Installing configuration..."
	@install -Dm0644 src/recap.conf $(DESTDIR)$(SYSCONFDIR)/recap
	@echo "Installing cron job..."
	@install -Dm0644 src/recap.cron $(DESTDIR)$(CRONDIR)/recap
	@sed -i 's,/usr/sbin/,$(BINDIR)/,' $(DESTDIR)$(CRONDIR)/recap
	@echo "Installing docs..."
	@install -dm0755 $(DESTDIR)$(DOCDIR)/recap
	@install -Dm0644 CHANGELOG.md README.md COPYING -t $(DESTDIR)$(DOCDIR)/recap
	@echo "Creating log directories..."
	@install -dm0750 $(DESTDIR)$(LOGDIR)/recap
	@install -dm0750 $(DESTDIR)$(LOGDIR)/recap/backups
	@install -dm0750 $(DESTDIR)$(LOGDIR)/recap/snapshots

uninstall:
	@echo "Removing scripts..."
	@rm -f $(DESTDIR)$(BINDIR)/recap
	@rm -f $(DESTDIR)$(BINDIR)/recaplog
	@rm -f $(DESTDIR)$(BINDIR)/recaptool
	@echo "Removing man pages..."
	@rm -f $(DESTDIR)$(MANDIR)/man5/recap.5
	@rm -f $(DESTDIR)$(MANDIR)/man8/recap.8
	@rm -f $(DESTDIR)$(MANDIR)/man8/recaplog.8
	@rm -f $(DESTDIR)$(MANDIR)/man8/recaptool.8
	@echo "Removing docs..."
	@rm -Rf $(DESTDIR)$(DOCDIR)/recap
	@echo "Removing configuration..."
	@rm -f $(DESTDIR)$(SYSCONFDIR)/recap
	@echo "Removing cron job..."
	@rm -f $(DESTDIR)$(CRONDIR)/recap

.PHONY: install uninstall purge
