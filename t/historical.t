#!perl

use strict;
use warnings;
use Test::More;

use FixerIO::Endpoint::Historical;

my $data = {
    success => 1,
    historical => 1,
    date => "2013-12-24",
    timestamp => 1387929599,
    base => "GBP",
    rates => {
        USD => 1.636492,
        EUR => 1.196476,
        CAD => 1.739516
    }
};

my $r = FixerIO::Endpoint::Historical::Response->new($data);

is $r->success, $data->{success}, 'success';
is $r->historical, $data->{historical}, 'historical';
is $r->date, $data->{date}, 'date';
is $r->timestamp, $data->{timestamp}, 'timestamp';
is $r->base, $data->{base}, 'base';
is_deeply scalar($r->rates), $data->{rates}, 'rates';


my $module = 'FixerIO::Endpoint::Historical';
my $historicalResponse = "${module}::Response";

my $harrysKey='5c133d07d477c48aaefaf549082d7126';

require_ok $module
    or BAIL_OUT
"Does fixer.t pass all tests?
Is the \$accessKey defined?
Is there access to the internet?";

my $theDate = '2013-12-24';
my $hist = new_ok $module => [$harrysKey, $theDate];

is  "$hist",
    'http://data.fixer.io/api/' . $theDate . '?access_key='.$harrysKey,
    'Endpoint URL is correct.';

my $newBase = 'USD';
$hist->base($newBase);
is  "$hist",
    'http://data.fixer.io/api/' . $theDate . '?access_key='.$harrysKey . '&base=' . $newBase,
    'set base (currency) URL is correct.';

$hist->base();
is  "$hist",
    'http://data.fixer.io/api/' . $theDate . '?access_key='.$harrysKey,
    'reset base to default URL is correct.';

my @mySymbols = qw(USD GBP JPY BTC);
$hist->symbols(@mySymbols);
is  "$hist",
    'http://data.fixer.io/api/' . $theDate . '?access_key='.$harrysKey . '&symbols=' . join(',', @mySymbols),
    'set symbols URL is correct.';

$hist->symbols();
is  "$hist",
    'http://data.fixer.io/api/' . $theDate . '?access_key='.$harrysKey,
    'reset symbols empty is correct.';

can_ok $hist, 'get_response';
$hist->symbols(@mySymbols); # Save some bandwidth

my $response = $hist->get_response;
isa_ok $response, $historicalResponse;

my $save = $response;
$response = $hist->get_response;

is $response, $save, 'eTag is working';

$response = $hist->force_new->get_response;

isnt $response, $save, 'force_new is working';

is_deeply $response, $save, 'The data is the same, see?';

done_testing();
exit;
