package coding_task_BE_api;
use Dancer2;

use WordFinder;
my $wordfinder = new WordFinder;

our $VERSION = '0.1';

set serializer => 'JSON';

get '/wordfinder/:input' => sub {

	my @words = ();
	my $input = params->{ 'input' };

	$wordfinder->alpha_chars($input);

	@words = $wordfinder->build_words;

	return \@words;
};

true;
