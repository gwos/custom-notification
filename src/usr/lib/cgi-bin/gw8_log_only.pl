#!/usr/bin/perl -w
#
######################################################
######################################################
#
# This script consumes variables from GroundWork Messenger, which are
# passed to it VIA headers utilizing the GroundWork Messenger curl method.
# It is meant to be executed as a CGI VIA curl.
#
# This particular example is a log-only method, which ships to the container log (stderr).
#
#
######################################################
######################################################
#
#
# GroundWork Messenger curl method template:
#-X GET http://custom-notification:5151/cgi-bin/snow_gw8.pl -H "COMMENTS: [COMMENTS]" -H "HOSTNAME: [HOSTNAME]" -H "INCIDENTDURATION: [INCIDENTDURATION]" -H "INCIDENTTZ: [INCIDENTTZ]" -H "INCIDENTUTC: [INCIDENTUTC]" -H "INCIDENTUTCMS: [INCIDENTUTCMS]" -H "MONITORINGOUTPUT: [MONITORINGOUTPUT]" -H "NOTIFICATIONRULE: [NOTIFICATIONRULE]" -H "NOTIFICATIONTIME: [NOTIFICATIONTIME]" -H "PRIORSTATUS: [PRIORSTATUS]" -H "RESOURCETYPE: [RESOURCETYPE]" -H "STATUS: [STATUS]" -H "SERVICENAME: [SERVICENAME]" -H "SERVICEGROUPS: [SERVICEGROUPS]" -H "UPDATETZ: [UPDATETZ]" -H "UPDATEUTC: [UPDATEUTC]" -H "UPDATEUTCMS: [UPDATEUTCMS]" -H "AUTHOR: [AUTHOR]"
#
######################################################


# Modules below used for CGI
use strict;
use warnings;
use CGI;

# stderr is a bit ugly, but it works as a good default. If you want to log to a file:
# - add the file as a volume to docker-compose.override.yml
#
# When sent by GroundWork messenger, the audit log will have these "sent" alerts anyway,
# so there isn't much need for persistent logging.
#
my $log_file         = "/var/log/custom_notification.log";
my $q = CGI->new;
my %headers = map { $_ => $q->http($_) } $q->http();

# Our print statments should include a browser-friendly status when we need to return data.
# This only applies to situations in which the data is returned to the requestor.
#
# For instance, if we cannot open the log file, and the intent of this script is to log things,
# we should make sure the caller of this script knows that something is broken.
open(LOG, '>', "$log_file") or die "Status: 500 Internal Server error", "\n\n ERROR:  Cannot open logfile for STDERR:  $!\n";
print LOG "New request for log-only custom method recieved headers: \n";
for my $header ( keys %headers ) {
    print LOG "         $header: $headers{$header}      ";
}
print "\n";
close(LOG);
print "Status: 200 OK", "\n\n";
exit 0
