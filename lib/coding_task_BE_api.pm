package coding_task_BE_api;
use Dancer2;

our $VERSION = '0.1';

set serializer => 'JSON';

get '/wordfinder/:input' => sub {

	my $input_chars = params->{ 'input' };

	my @words = qw(one two);

	return {@words};
};

true;
