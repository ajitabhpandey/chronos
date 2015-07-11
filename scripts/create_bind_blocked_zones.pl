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
use 5.014;

my $dl_tool;
my @host_names;

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
#my @urls = ( "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml" );
my @urls = ( "http://someonewhocares.org/hosts/hosts" );

# holds the lines read
my $lines_read = 0;

# holds the number of records processed
my $records = 0;

# Get the list of domains and create a zones file out of it
foreach my $url (@urls) {
    # Open the URL
    open(WWWPAGE, "$dl_tool $url |") || die "Cannot execute $dl_tool: $@\n";

    printf( "//Created on %s from %s\n\n", scalar localtime, $url);

    while (<WWWPAGE>) {
         $lines_read++;

         chomp;
		 # ignore lines starting with #
         next if /^\s*#/;

		 # ignore blank lines 
         next if /^\s*$/;

		 # get the second field from the host file which has the hostname
	 	 my($ip, $host) = split;
	 
		 # ignore the localhost and broadcasthost entries
	 	 next if ($host =~ /\s*local.*/) or ($host =~ /\s*broadcasthost\s*/ );
         $records++;
		 
		 # adding the host name to an array		 
		 push @host_names, $host;
		 
    }

	# get the unique values
	# there is no particular order. works only in Perl 5.14 onwards as 
	# keys function can be used on hash references from 5.14 
	my @unique_host_names = keys { map { $_ => 1 } @host_names };
	
	# for cases where working with perl version lower than 5.14, use the below logic to get unique values
	# my @unique_host_names = do { my %seen; grep { !$seen{$_}++ } @host_names };
	
	# dumping the zone definitions
	foreach (@unique_host_names) {
		printf("zone \"%s\" { type master\; notify no\; file \"/etc/bind/db.blocked\"\; }\;\n", $_);
	}

    my $message = "Lines read: $lines_read, Processed: $records, Wrote: ".scalar @unique_host_names." from $url";
    system("/usr/bin/logger -t $0 $message");
}

