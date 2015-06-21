#!/usr/bin/perl
# create_bind_blocked_zones.pl 
# ajitabhpandey at ajitabhpandey dot info
# Created - 17th June 2015
# Description -
# Create bind zone definitions for blocking certain domains at DNS level.
# The output of all zones created is on standard output and is seperated by newline
# Format of the zone file created - 
# zone "example.com" { type master; notify no; file "/etc/bind/db.blocked"; };
# The format for the bind db.blocked file is - 
#   ; BIND data file for blocked domains
#   ;
#   $TTL    604800
#   @       IN      SOA     blocked.example.com. root.example.com. (
#                            201506150     ; Serial
#                            604800        ; Refresh
#                            86400         ; Retry
#                            2419200       ; Expire
#                            604800 )      ; Negative Cache TTL
#   ;
#   @       IN      NS      ns1.blocked.example.com.
#   @       IN      A       192.168.0.52
#   *       IN      A       192.168.0.52
#
use strict;
use warnings;

my $dl_tool;
#
# search path for either wget or curl
for my $path ( split /:/, $ENV{PATH} ) {
    if ( -f "$path/wget" && -x _ ) {
         $dl_tool = "wget -q -O - ";
    }
}

for my $path ( split /:/, $ENV{PATH} ) {
    if ( -f "$path/curl" && -x _ ) {
        $dl_tool = "curl -q";
    }
}

die "Neither curl not wget found in path" unless defined($dl_tool) and length $dl_tool;

# List of URLs to be blocked.
my @urls = ( "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml" );

# holds the number of records processed
my $records = 0;

# Get the list of domains and create a zones file out of it
foreach my $url (@urls) {
    # Open the URL
    open(WWWPAGE, "$dl_tool $url |") || die "Cannot execute $dl_tool: $@\n";

    printf( "//Created on %s from %s\n\n", scalar localtime, $url);

    while (<WWWPAGE>) {
         chomp;
         $records++;
         printf("zone \"%s\" { type master\; notify no\; file \"/etc/bind/db.blocked\"\; }\;\n", $_);
         #print  " file \"/etc/bind/db.blocked\"\; }\;\n";
    }

    my $message = "Total zones created: $records from $url";
    system("/usr/bin/logger -t $0 $message");
}

