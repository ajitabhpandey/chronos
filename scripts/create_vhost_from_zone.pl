#!/usr/bin/perl
# create_vhost_from_zone.pl
# ajitabhpandey at ajitabhpandey dot info
# Created on 20th June 2015
# Description - 
# Converts a bind zone file entry into virtual host file for web server.
# At this moment vhost file of monkey httpd server are supported
# The zone files can be supplied as stdin and accordingly a virtual host file definition will be created
# Format of the zone file - 
# zone "example.com" { type master; notify no; file "/etc/bind/db.blocked"; };
# Format of the virtual host definition - 
# # example.com - Configuration
# [HOST]
#        ServerName example.com
#        DocumentRoot /path/to/documentroot/for/domain
# Example Usage -
# echo zone "example.com" { type master; notify no; file "/etc/bind/db.blocked"; };|create_vhost_from_zone.pl
#
use strict;
use warnings;

my $DOCROOT = "/media/WD260/www/blocked-domains";
my $records_processed = 0;
my $records_read = 0;
my $vhost_file_location = "/etc/monkey/sites/";
my $lines_read = 0;

while (<>) {
  $lines_read++;
  chomp;
# skip blank lines
  next if /^\s*$/;
# will skip if the line start with // or #
  next if /^\s*\/\//;
# remove double quotes from the line
  s/\"//g;

# increment the records read counter after ignoring comments and blank lines
  $records_read++;

# splits the line on the basis of white space
  my @fields = split;

  my $file = $vhost_file_location . $fields[1];

  # skip if the vhost definition file exists
  next if -f $file;

  open(my $fh, ">", $file) 
    or die "Can not open file $file: $!" ; 

  print $fh "# ", $fields[1], " - Configuration\n";
  print $fh "[HOST]\n";
  print $fh "\tServerName ", $fields[1], "\n";
  print $fh "\tDocumentRoot ", $DOCROOT, "\n";

  close $fh;

  $records_processed++;
}

my $message = "Input Lines: $lines_read, Processed: $records_read, Wrote: $records_processed";
system("/usr/bin/logger -t $0 $message");
