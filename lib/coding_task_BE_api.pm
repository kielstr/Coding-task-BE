package coding_task_BE_api;
use Dancer2;

use WordFinder;
my $wordfinder = new WordFinder;



set serializer => 'JSON';

# Web Service
# 	returns a JSON array of all words that can be built
# 	from the given letters. Not all input letters have to be used.
# 	Input letters can only be used once each.

# Dig deeper, there is two version of this logic ;)

# Calls version 1 of the code
get '/wordfinder/:input' => sub {

	my @words = ();
	my $input = params->{ 'input' };

	# check the input is valid and error or move on.
	unless ( $wordfinder->valid_str($input) ) {
		return {status => 'failed', error => 'Invalid input characters [a-z]' }
	}

	# tell the application what characters where are using.
	$wordfinder->alpha_chars($input);

	# ask it to build and return the words it knows about.
	@words = $wordfinder->build_words;

	return \@words;
};

# Calls version 2 of the code
get '/wordfinder2/:input' => sub {

	my @words = ();
	my $input = params->{ 'input' };

	# check the input is valid and error or move on.
	unless ( $wordfinder->valid_str($input) ) {
		return {status => 'failed', error => 'Invalid input characters [a-z]' }
	}

	# tell the application what characters where are using.
	$wordfinder->alpha_chars($input);

	# ask it to build and return the words it knows about.
	@words = $wordfinder->build_words2;

	return \@words;
};

true;
