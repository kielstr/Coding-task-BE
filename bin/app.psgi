#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use coding_task_BE;
use coding_task_BE_api;

use Plack::Builder;
builder {
	mount '/' => coding_task_BE_api->to_app;
	mount '/ping' => coding_task_BE->to_app;
}
