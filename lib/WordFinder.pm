package WordFinder;

use strict;
use warnings;

use Moo;

use Carp;
use Data::Dumper qw(Dumper);

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

has alpha_chars_aref => ( 
	is => 'rw', 
	isa => sub {
       confess "'$_[0]' is not an array reference!"
          if ref $_[0] ne 'ARRAY';
    }, 
);

has input_char_counts_href => ( 
	is => 'rw', 
	isa => sub {
       confess "'$_[0]' is not an hash reference!"
          if ref $_[0] ne 'HASH';
    }, 
);


after alpha_chars => sub {
	my ( $self, $alpha_chars ) = @_;

	return unless $alpha_chars;

	my @alpha_chars_array = split '', $alpha_chars;

	$self->alpha_chars_aref(\@alpha_chars_array);

	my $input_char_counts_href = {};

	$input_char_counts_href->{ $_ }++ for @{ $self->alpha_chars_aref };

	$self->input_char_counts_href($input_char_counts_href);
};

sub BUILD {
	my $self = shift;
	# Parse file

	my $words = $self->dictionary;

	open my $dict_fh, '<', '/usr/share/dict/words' 
		or croak "failed to open file /usr/share/dict/words $!";

	while ( defined ( $_ = $dict_fh->getline ) ) {
		chomp;
		next unless length $_ > 1;
		push @$words, $_;
	}

	$dict_fh->close;

	$self->dictionary( $words );
}

sub build_words {
	my $self = shift;

	my %words;

	my $input_char_counts_href = $self->input_char_counts_href;

	my $allowed_chars = 
		join '|', keys %$input_char_counts_href;


	my $total_tests_passed = 0;

	for my $word ( grep /^($allowed_chars)+$/, @{ $self->dictionary } ) {
		for my $input_char ( @{ $self->alpha_chars_aref } ) {

			# if the charactor is not found in the current word 
			# qualify the test and move on.
			unless ($word =~ /$input_char/ ) {
				$total_tests_passed++;
				next;
			}

			# count the amount of times the charactor is found in the current word.
			my $input_char_count = () = $word =~ /$input_char/g;

			# if the charactor is found the correct amount of times mark the test as pass.
			if ($input_char_count <= $input_char_counts_href->{$input_char}) {
				$total_tests_passed++
			}
		}

		# Total tests passed must match the length of the input string.
		if ( $total_tests_passed eq int @{ $self->alpha_chars_aref } ) {
			$words{$word}++;
		}

		$total_tests_passed = 0;
	}

	return keys %words;
}

sub build_words2 {
	my $self = shift;
	my @words;
	
	my $input_char_counts_href = $self->input_char_counts_href;

	my $allowed_chars = 
		join '|', keys %$input_char_counts_href;

	my $regex_filter;
	for my $char ( keys %$input_char_counts_href ) {
		$regex_filter .= qq/
			^($char)
			(?=
				(?!(.*$char){$input_char_counts_href->{$char}})
		/;
	
		for ( keys %$input_char_counts_href ) {
			next if $_ eq $char;
			$regex_filter .= "\t\t(?!(.*$_){" . ($input_char_counts_href->{$_}+1) . "})\n"
		}

		$regex_filter .= qq/
			)($allowed_chars)+
		\$
		|/;
	}

	$regex_filter =~ s/\|$//;
	
	@words = grep /$regex_filter/x, @{ $self->dictionary };
	return @words;
}

1;
