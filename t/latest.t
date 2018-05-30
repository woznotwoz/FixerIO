#!perl

use strict;
use warnings;
use Test::More;

use FixerIO::Endpoint::Latest;

my $data = {
    success =>  1,
    timestamp =>  1519296206,
    base =>  "USD",
    date =>  "2018-05-17",
    rates =>  {
        GBP =>  0.72007,
        JPY =>  107.346001,
        EUR =>  0.813399
    }
};

my $r = FixerIO::Endpoint::Latest::Response->new($data);

is $r->success, $data->{success}, 'success';
is $r->base, $data->{base}, 'base';
is $r->timestamp, $data->{timestamp}, 'timestamp';
is $r->date, $data->{date}, 'date';
is_deeply scalar($r->rates), $data->{rates}, 'rates';


my $module = 'FixerIO::Endpoint::Latest';
my $latestResponse = "${module}::Response";

my $harrysKey='5c133d07d477c48aaefaf549082d7126';

require_ok $module
    or BAIL_OUT
"Does fixer.t pass all tests?
Is the \$accessKey defined?
Is there access to the internet?";

my $latest = new_ok $module => [$harrysKey];

is  "$latest",
    'http://data.fixer.io/api/latest?access_key='.$harrysKey,
    'Endpoint URL is correct.';

my $newBase = 'USD';
$latest->base($newBase);
is  "$latest",
    'http://data.fixer.io/api/latest?access_key='.$harrysKey . '&base=' . $newBase,
    'set base (currency) URL is correct.';

$latest->base();
is  "$latest",
    'http://data.fixer.io/api/latest?access_key='.$harrysKey,
    'reset base to default URL is correct.';

my @mySymbols = qw(USD GBP JPY BTC);
$latest->symbols(@mySymbols);
is  "$latest",
    'http://data.fixer.io/api/latest?access_key='.$harrysKey . '&symbols=' . join(',', @mySymbols),
    'set symbols URL is correct.';

$latest->symbols();
is  "$latest",
    'http://data.fixer.io/api/latest?access_key='.$harrysKey,
    'reset symbols empty is correct.';

can_ok $latest, 'get_response';
$latest->symbols(@mySymbols);

my $response = $latest->get_response;
isa_ok $response, $latestResponse;

my $save = $response;
$response = $latest->get_response;

is $response, $save, 'eTag is working';

$response = $latest->force_new->get_response;

isnt $response, $save, 'force_new is working';

is_deeply $response, $save, 'The data are the same, see?';

done_testing();
exit;
