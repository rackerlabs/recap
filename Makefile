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

# The File gzip command
ZIPPIT=                 gzip

################################################################################

all: install manpage doc
        @echo "make all output stub"

install:
        @echo "install debug stub"
        # make a directory
        ${MAKEDIR} ${DESTDIR}/${SBINDIR}
        # copy recap & freinds to sbin
        ${COPY} ${NAME} ${DESTDIR}/${SBINDIR}
        ${COPY} recaplog ${DESTDIR}/${SBINDIR}
        ${COPY} recaptool ${DESTDIR}/${SBINDIR}

        # make some directories for persistant logs & reports
        ${MAKEDIR} ${DESTDIR}/${LOGDIR}/${NAME}/backups
        ${MAKEDIR} ${DESTDIR}/${LOGDIR}/${NAME}/snapshots

        # make directory & copy config file
        ${MAKEDIR} ${DESTDIR}/${SYSCONFDIR}/${NAME}
        ${COPY} recap.conf ${DESTDIR}/${SYSCONFDIR}/${NAME}



manpage:
	    # Zip it up
	    ${ZIPPIT} recap.5
	    ${ZIPPIT} recap.8	
        # place man pages
        ${MAKEDIR} ${DESTDIR}/${MANDIR}/man5
        ${COPY} recap.5.gz ${DESTDIR}/${MANDIR}/man5
        ${MAKEDIR} ${DESTDIR}/${MANDIR}/man8
        ${COPY} recap.8.gz ${DESTDIR}/${MANDIR}/man8
        
        
doc:
        # copy documentation to the proper place
        ${MAKEDIR} ${DOCDIR}
        ${COPY} README.md ${DOCDIR}
        ${COPY} TODO ${DOCDIR}
        ${COPY} CHANGELOG ${DOCDIR}
        ${COPY} COPYING ${DOCDIR}



clean:
        @echo "We're clean!"
        



#
