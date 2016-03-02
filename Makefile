# Created by: Ryan Stark
# rackerlabs/recap/Makefile

NAME=                   recap
VERSION=                0.9.8

MAINTAINER=             recap@lists.rackspace.com
COMMENT=                Script that generates reports of various usage statistics about a server
# Created by: Ryan Stark
# rackerlabs/recap/Makefile

NAME=                   recap
VERSION=                0.9.8

MAINTAINER=             recap@lists.rackspace.com
COMMENT=                Script that generates reports of various usage statistics about a server

LICENSE=                GPLv2

QUIET=                  @

# DESTDIR used for sandbox testing. Replace with /
DESTDIR=                /

#Where logs live
LOGDIR=                 /var/log

# Where to place the man page
MANPATH=                /usr/share/man

# Where to place the running code
SBINDIR=                /usr/sbin

# document root
DATADIR=                /usr/share

# Where to place the user documentation
DOCDIR=                 ${DESTDIR}/${DATADIR}/doc/${PROG}-${VERSION}

# Where to place man pages
MANDIR=                 ${DESTDIR}/${MANPATH}/

# Where config files are placed
SYSCONFDIR=             /etc

# The file copy command (copy but do not delete original)
COPY=                   cp

# The make directory (hierarchy) command
MAKEDIR=                mkdir -p

# The file move command (move and delete original)
MOVE=                   mv

# The file delete command
DELETE=                 rm

# this is here
ROOT_UID=               0

# The command to unzip
UNZIPPIT=				gunzip

################################################################################

all:
	@echo "Nothing to compile, run make install"

install: binary manpage doc
	@echo "Installing everything"

binary:
	@echo "install debug stub"
	${QUIET}echo "make a directory"
	${QUIET}${MAKEDIR} ${DESTDIR}/${SBINDIR}
	${QUIET}echo "recap & freinds to sbin"
	${QUIET}${COPY} src/${NAME} ${DESTDIR}/${SBINDIR}
	${QUIET}${COPY} src/recaplog ${DESTDIR}/${SBINDIR}
	${QUIET}${COPY} src/recaptool ${DESTDIR}/${SBINDIR}

	${QUIET}echo "make some directories for persistant logs & reports"
	${QUIET}${MAKEDIR} ${DESTDIR}/${LOGDIR}/${NAME}/backups
	${QUIET}${MAKEDIR} ${DESTDIR}/${LOGDIR}/${NAME}/snapshots

	${QUIET}echo "make directory & copy config file"
	${QUIET}${MAKEDIR} ${DESTDIR}/${SYSCONFDIR}/${NAME}
	${QUIET}${COPY} src/recap.conf ${DESTDIR}/${SYSCONFDIR}/${NAME}



manpage:
	${QUIET}echo "place man pages"
	${QUIET}${MAKEDIR} ${DESTDIR}/${MANDIR}/man5
	${QUIET}${COPY} src/recap.5 ${DESTDIR}/${MANDIR}/man5
	${QUIET}${MAKEDIR} ${DESTDIR}/${MANDIR}/man8
	${QUIET}${COPY} src/recap.8 ${DESTDIR}/${MANDIR}/man8
		
		
doc:
	${QUIET}echo "copy documentation to the proper place"
	${QUIET}${MAKEDIR} ${DOCDIR}
	${QUIET}${COPY} README.md ${DOCDIR}
	${QUIET}${COPY} TODO ${DOCDIR}
	${QUIET}${COPY} CHANGELOG ${DOCDIR}
	${QUIET}${COPY} COPYING ${DOCDIR}


		
uninstall:
	${QUIET}echo "getting rid of binaries"
	${QUIET}${DELETE} ${DESTDIR}/${SBINDIR}/${NAME}
	${QUIET}${DELETE} ${DESTDIR}/${SBINDIR}/recaplog
	${QUIET}${DELETE} ${DESTDIR}/${SBINDIR}/recaptool
	${QUIET}echo "get rid of man pages"
	${QUIET}${DELETE} ${DESTDIR}/${MANDIR}/man5/recap.5.gz
	${QUIET}${DELETE} ${DESTDIR}/${MANDIR}/man8/recap.8.gz
	${QUIET}echo "get rid of docs"
	${QUIET}${DELETE} -rf ${DOCDIR}
	${QUIET}echo "we'll leave the conf directory"


#
