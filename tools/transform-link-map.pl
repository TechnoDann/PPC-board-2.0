#!/usr/bin/env perl
use strict;
use warnings;
use 5.022;

use File::Basename;
use File::Path qw(make_path);

if (scalar @ARGV == 1 && $ARGV[0] == "-h") {
    print "Usage: $0 [in_file] [out_file]\n";
    exit;
}

my $ifh = (scalar @ARGV >= 1 && $ARGV[0] != "-") ? open($ARGV[0], '<') : (*STDIN);
my $ofh = (scalar @ARGV >= 2 && $ARGV[1] != "-") ? open($ARGV[1], '>') : (*STDOUT);
print $ofh "old_url,new_url,id,date\n";

while (<$ifh>) {
    next unless /^(.*),(\d+),(.*),(\d{4})-(\d{2})-(\d{2}).*$/;
    my $url = $1;
    my $id = $2;
    my $date = $3;
    my $root_year = $4;
    my $root_month = $5;
    my $root_day = $6;
    my $root_day_letter = "x";
    if ($root_day < 10) {
        $root_day_letter = "a";
    }
    elsif ($root_day >= 10 && $root_day < 20) {
        $root_day_letter = "b";
    }
    else {
        $root_day_letter = "c";
    }
    print $ofh "$url,/archive/$root_year/${root_month}${root_day_letter}#post-$id,$id,$date\n";
}

close $ifh;
close $ofh;
