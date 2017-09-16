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

	my $chars_formated = join '|', @{ $self->alpha_chars_array_ref };

	my $input = $self->alpha_chars;

	# Bug here! what to do with input containing duplicate? i.e test

	my $regex =qr/
		# Input letters can only be used once each however, it seems logical 
		# to include the word supplied if its a direct match.

		^$input$

		|

		# Only include words that contain the input chars once. 

		^(
			# match any words starting with any of the in characters
			(?'search_char'($chars_formated)) 
			
			# We don't want any words with the match characters repeated.
			(?!.*(\g{search_char})) 
		)+$
	/x;

	my @buffer = grep /$regex/, @{ $self->dictionary };


	return @buffer;
}

1;
