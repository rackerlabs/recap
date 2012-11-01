# Allow accessing recap logs from apache, disabled by default

#Alias /recap /var/log/recap
#
#<Location /recap>
#    Order deny,allow
#    Deny from all
#    Allow from 127.0.0.1 localhost
#    Allow from ::1
# Rackspace example
#    Allow from .rackspace.com
#</Location>