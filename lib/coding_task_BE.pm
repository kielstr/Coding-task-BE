package coding_task_BE;
use Dancer2;

our $VERSION = '0.1';

# Package to handle returning the plain text 'OK\n'
# detailed https://github.com/strategicdata/recruitment/wiki/Coding-task---BE
# 

#
#	/ping -- returns 200 OK
#

#	$ curl http://localhost:8080/ping
#	OK

get '/' => sub {
	return "OK\n";
};

true;
