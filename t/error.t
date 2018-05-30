#!perl

use strict;
use warnings;
use Test::More;

use FixerIO::Endpoint;
use FixerIO::Endpoint::Error;

my $data = {
  "success" => 0,
  "error" => {
    "code" => 104,
    "type" => 'mock_error',
    "info" => "Your monthly API request volume has been reached. Please upgrade your plan."    
  }
};

my $r = FixerIO::Endpoint::Error->new($data);

is $r->success, $data->{success}, 'success, (not)';
is $r->code, $data->{error}{code}, 'code';
is $r->type, $data->{error}{type}, 'type';
is $r->info, $data->{error}{info}, 'info';


sub api_error_forced {
    my $url = shift;

    my $errorObject = FixerIO::Endpoint::get_response($url);

    return $errorObject;
}

sub dies_like(&$$) {
    my( $code, $expected, $message ) = @_;
    eval { $code->() };
    like $@ => $expected, $message;
}


my $module = 'FixerIO::Endpoint::Error';

my $harrysKey='5c133d07d477c48aaefaf549082d7126';

require_ok $module
    or BAIL_OUT
"Does fixer.t pass all tests?
Is the \$accessKey defined?
Is there access to the internet?";


# Let's try for some errors...
my $error = api_error_forced(
    'http://data.fixer.io/api/symbols'
);
#    'http://data.fixer.io/api/latest?access_key='.$harrysKey.'1'

dies_like { $error->rates() }
          qr/Can't locate object method ".*" via package ".*"/,
	  "Perl dies() if you try and call a method that doesn't exist.";


isa_ok ($error, $module, 'error object');

can_ok $error, qw(code type info);

is $error-> code, '101', 'Forgot to include $access_key with the URL';
# is $error-> type, 'missing_access_key', 'See, that is the problem.';
# is $error-> info, 'You have not supplied an API Access Key. [Required format: access_key=YOUR_ACCESS_KEY]', 'some helpful info';

done_testing();


