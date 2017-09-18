use strict;
use warnings;

use Test::More tests => 6;
use Plack::Test;
use HTTP::Request;
use JSON;

use FindBin qw($RealBin);
use lib "$RealBin/../lib";
use feature 'say';
say "$RealBin";

use coding_task_BE;
use coding_task_BE_api;

my $app = coding_task_BE->to_app;

my $test = Plack::Test->create($app);

# Test the service resonds correctly to a ping 
my $request  = HTTP::Request->new( GET => '/' );
my $response = $test->request($request);

ok( $response->is_success, '[GET /ping] Successful request' );
is( $response->content, "OK\n", '[GET /ping] Correct content' );

my $app_api = coding_task_BE_api->to_app;

$test = Plack::Test->create($app_api);

# Test the service resonds correctly to a build words request 

$request  = HTTP::Request->new( GET => '/wordfinder/dgo' );
$response = $test->request($request);

my $content_parsed = from_json($response->content);
ok( $response->is_success, '[GET /wordfinder/:input] Successful request' );
is( ref($content_parsed), "ARRAY", '[GET /wordfinder/:input] Correct content' );


# Test the service resonds correctly to a build words version 2 request 
$request  = HTTP::Request->new( GET => '/wordfinder2/dgo' );
$response = $test->request($request);

$content_parsed = from_json($response->content);
ok( $response->is_success, '[GET /wordfinder2/:input] Successful request' );
is( ref($content_parsed), "ARRAY", '[GET /wordfinder2/:input] Correct content' );


# Would like to add more tests here ;)

done_testing();
