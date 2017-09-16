package WordFinder;

use strict;
use warnings;

use Moo;

use Carp;
use Data::Dumper qw(Dumper);

use feature 'say';

has dictionary => ( 
	is => 'rw', 
	isa => sub {
       confess "'$_[0]' is not an array reference!"
          if ref $_[0] ne 'ARRAY';
    }, 
);

has alpha_chars => ( 
	is => 'rw', 
	isa => sub {
       confess "'$_[0]' is not an alpha character!"
          if $_[0] !~ /^[a-z|A-Z]+$/;
    }, 
);

has alpha_chars_array_ref => ( 
	is => 'rw', 
	isa => sub {
       confess "'$_[0]' is not an array reference!"
          if ref $_[0] ne 'ARRAY';
    }, 
);

after alpha_chars => sub {
	my ( $self, $alpha_chars ) = @_;

	return unless $alpha_chars;

	my @alpha_chars_array = split '', $alpha_chars;

	$self->alpha_chars_array_ref(\@alpha_chars_array);
};


sub BUILD {
	my $self = shift;
	# Parse file

	my $words = $self->dictionary;

	open my $dict_fh, '<', '/usr/share/dict/words' 
		or croak $_;

	while ( defined ( $_ = $dict_fh->getline ) ) {
		chomp;
		next unless length $_ > 1;
		push @$words, $_;
	}

	close $dict_fh;

	$self->dictionary( $words );
}

sub build_words {
	my $self = shift;

	my %words;
	my $chars_formated = join '|', @{ $self->alpha_chars_array_ref };

	my %input_char_counts;
	$input_char_counts{ $_ }++ for @{ $self->alpha_chars_array_ref };

	my $total_tests_passed = 0;

	for my $word ( grep /^($chars_formated)+$/, @{ $self->dictionary } ) {
		for my $input_char ( @{ $self->alpha_chars_array_ref } ) {

			# if the charactor is not found in the current word 
			# qualify the test and move on.
			unless ($word =~ /$input_char/ ) {
				$total_tests_passed++;
				next;
			}

			# count the amount of times the charactor is found in the current word.
			my $input_char_counts = () = $word =~ /$input_char/g;

			# if the charactor is found the correct amount of times mark the test as pass.
			if ($input_char_counts <= $input_char_counts{$input_char}) {
				$total_tests_passed++
			}
		}

		# Total tests passed must match the length of the input string.
		if ( $total_tests_passed eq int @{ $self->alpha_chars_array_ref } ) {
			$words{$word}++;
		}

		$total_tests_passed = 0;
	}

	return keys %words;
}

sub build_words2 {
	my $self = shift;

	my %input_char_counts;
	$input_char_counts{ $_ }++ for @{ $self->alpha_chars_array_ref };

	my $chars_formated = join '|', map {'(' . $_ . '{1,' . $input_char_counts{$_} . '})' } keys %input_char_counts;
		
	say $chars_formated;


	my $regex = qr /
			^(
				(?'search_char'($chars_formated))
				(?!.*(\g{search_char}))

			)+$
	/x;

	my @words = grep /$regex/, @{ $self->dictionary };
	return @words;
}

1;
