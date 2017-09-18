package WordFinder;

use strict;
use warnings;

use Moo;

use Carp;
use Data::Dumper qw(Dumper);

# Location of the words file. 
# Quick way to get one is apt-get update && apt-get -y install wamerican;

use constant DICT_FILE => '/usr/share/dict/words';

our $VERSION = '1';

# Store for the list of words.
has dictionary_aref => ( 
	is => 'rw', 
	isa => sub {
       confess "'$_[0]' is not an array reference!"
          if ref $_[0] ne 'ARRAY';
    }, 
);

# The users raw characters
has alpha_chars => ( 
	is => 'rw', 
	isa => sub {
       confess "'$_[0]' is not the correct input /^[a-z]+$/!"
          if $_[0] !~ /^[a-z]+$/;
    }, 
);

# We create a list of the input characters and store it here.
has alpha_chars_aref => ( 
	is => 'rw', 
	isa => sub {
       confess "'$_[0]' is not an array reference!"
          if ref $_[0] ne 'ARRAY';
    }, 
);

# Store a count of the amount a characters appears in the 
# input.
has input_char_counts_href => ( 
	is => 'rw', 
	isa => sub {
       confess "'$_[0]' is not an hash reference!"
          if ref $_[0] ne 'HASH';
    }, 
);

# if alpha_chars is being populated then reformat the input into a
# array_ref and count the amount of times characters appears in 
# the input
after alpha_chars => sub {
	my ( $self, $alpha_chars ) = @_;

	return unless $alpha_chars;

	my @alpha_chars = split '', $alpha_chars;

	$self->alpha_chars_aref(\@alpha_chars);

	my $input_char_counts_href = {};

	$input_char_counts_href->{ $_ }++ for @{ $self->alpha_chars_aref };

	$self->input_char_counts_href($input_char_counts_href);
};

# Read in the words and build the dictionary array_ref.
sub BUILD {
	my $self = shift;

	my $words_aref = $self->dictionary_aref;

	open my $dict_fh, '<', DICT_FILE 
		or croak 'failed to open file ' . DICT_FILE . " $!";

	while ( defined ( $_ = $dict_fh->getline ) ) {
		chomp;
		next unless length $_ > 1;
		push @$words_aref, $_;
	}

	$dict_fh->close;

	$self->dictionary_aref( $words_aref );
}


# 	
# 	returns a JSON array of all words that can be built
# 	from the given letters. Not all input letters have to be used.
# 	Input letters can only be used once each.


# version 1)

# Using looping logic. 

sub build_words {
	my $self = shift;

	my %words;
	my $total_tests_passed = 0;

	my $input_char_counts_href = $self->input_char_counts_href;

	my $allowed_chars = 
		join '|', keys %$input_char_counts_href;

	for my $word ( grep /^($allowed_chars)+$/, @{ $self->dictionary_aref } ) {
		for my $input_char ( @{ $self->alpha_chars_aref } ) {

			# if the character is not found in the current word 
			# qualify the test and move on.
			unless ( $word =~ /$input_char/ ) {
				$total_tests_passed++;
				next;
			}

			# count the amount of times the character is found in the current word.
			my $input_char_count = () = $word =~ /$input_char/g;

			# if the character is found the correct amount of times mark the test as pass.
			if ( $input_char_count <= $input_char_counts_href->{$input_char} ) {
				$total_tests_passed++
			}
		}

		# total tests passed must match the length of the input string.
		if ( $total_tests_passed eq int @{ $self->alpha_chars_aref } ) {
			$words{$word}++;
		}

		$total_tests_passed = 0;
	}

	return keys %words;
}

# Version 2)

# Using a regex grep. I spent some time on this I thought I could use
# look-arounds to match all rules however got stuck on input like tset due to the multiple t.
# Was able to dynamically build a regex that performs the task. Hard to read but! 


sub build_words2 {
	my $self = shift;
	my ( @words, $regex_str );
	
	my $input_char_counts_href = $self->input_char_counts_href;

	my $allowed_chars = 
		join '|', keys %$input_char_counts_href;

	for my $char ( keys %$input_char_counts_href ) {
		$regex_str .= qq/
			^($char) # Only character inputted are allowed
			(?=
				(?!(.*$char){$input_char_counts_href->{$char}}) # followed buy the match char the total amount 
																# it appears in the input string
		/;
	
		for ( keys %$input_char_counts_href ) {
			# $char is handled above.
			next if $_ eq $char;

			$regex_str .= "\t\t(?!(.*$_){" . ($input_char_counts_href->{$_}+1) . "}) # And not followed by any other allowed char more than the total amount it appears in the input string \n"
		}

		$regex_str .= qq/
			)($allowed_chars)+ # Followed by any other allowed character
		\$
		|/;
	}

	$regex_str =~ s/\|$//;
	
	@words = grep /$regex_str/x, @{ $self->dictionary_aref };
	return @words;
}

# Helper to check the input string is valid
sub valid_str {
	my ( $self, $string ) = @_;
	return $string =~ /^[a-z]+$/ ? 1 : 0;
}

1;
