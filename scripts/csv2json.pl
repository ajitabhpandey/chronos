#!/usr/bin/perl
# Usage - cat file1.csv|cs2json.pl
#
use strict;
use warnings;
use Text::xSV;
use JSON::XS;

my $CSV = Text::xSV->new();
my $JSON = JSON::XS->new->canonical->utf8;
$CSV->read_header();
while (my $row = $CSV->fetchrow_hash) {
    print $JSON->encode($row) . "\n";
}