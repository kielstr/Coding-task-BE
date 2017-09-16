#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use FindBin qw($RealBin);
use lib $RealBin . '/../lib';

use WordFinder;
use Data::Dumper qw(Dumper);

my $wordfinder = new WordFinder;

my $input = $ARGV[0];

die "usage $0: <alpha characters>" 
	unless $input;

$wordfinder->alpha_chars($input);

my @matched_words = $wordfinder->build_words;

if ( @matched_words ) {
	say "Matched words:\n\t-- " . join ("\n\t-- ", @matched_words);
} else {
	say 'Failed to match any words to ' . $input;
}


