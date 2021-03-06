use strict;
use warnings;

use FindBin qw($RealBin);
use lib "$RealBin/../lib";

use coding_task_BE;
use Test::More tests => 2;
use Plack::Test;
use HTTP::Request::Common;

my $app = coding_task_BE->to_app;
is( ref $app, 'CODE', 'Got app' );

my $test = Plack::Test->create($app);
my $res  = $test->request( GET '/' );

ok( $res->is_success, '[GET /] successful' );
