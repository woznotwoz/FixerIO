#!perl

use strict;
use warnings;
use Test::More;

use FixerIO::Endpoint::Symbols;

my $data = {
  "success" => 1,
  "symbols" => {
    "AED" => "United Arab Emirates Dirham",
    "AFN" => "Afghan Afghani",
    "ALL" => "Albanian Lek",
    "AMD" => "Armenian Dram"
    }
}; 

my $r = FixerIO::Endpoint::Symbols::Response->new($data);

is $r->success, $data->{success}, 'success';
is_deeply scalar($r->symbols), $data->{symbols}, 'symbols';


my $module = 'FixerIO::Endpoint::Symbols';
my $symbolsResponse = "${module}::Response";

my $harrysKey='5c133d07d477c48aaefaf549082d7126';

require_ok $module
    or BAIL_OUT
"Does fixer.t pass all tests?
Is the \$accessKey defined?
Is there access to the internet?";

my $symbols = new_ok $module => [$harrysKey];

is  "$symbols",
    'http://data.fixer.io/api/' . 'symbols' . '?access_key='.$harrysKey,
    'Endpoint URL is correct.';

can_ok $symbols, 'get_response';

my $response = $symbols->get_response;
isa_ok $response, $symbolsResponse;

my $save = $response;
$response = $symbols->get_response;

is $response, $save, 'eTag is working';

$response = $symbols->force_new->get_response;

isnt $response, $save, 'Force_new is working, these are different objects.';

is_deeply $response, $save, 'The Data are the same, see?';

done_testing();
exit;
