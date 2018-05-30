#!perl

use strict;
use warnings;
use Test::More;

use FixerIO::Endpoint::Timeseries;

my $data = {
                success => 1,
                timeseries => 1,
                start_date => "2012-05-01",
                end_date => "2012-05-03",
                base => "EUR",
                rates => {
                    2012-05-01 =>{
                      USD => 1.322891,
                      AUD => 1.278047,
                      CAD => 1.302303
                    },
                    2012-05-02 => {
                      USD => 1.315066,
                      AUD => 1.274202,
                      CAD => 1.299083
                    },
                    2012-05-03 => {
                      USD => 1.314491,
                      AUD => 1.280135,
                      CAD => 1.296868
                    }
                }
            };

my $r = FixerIO::Endpoint::Timeseries::Response->new($data);

is $r->success, $data->{success}, 'success';
is $r->timeseries, $data->{timeseries}, 'timeseries';
is $r->start_date, $data->{start_date}, 'start_date';
is $r->end_date, $data->{end_date}, 'end_date';
is $r->base, $data->{base}, 'base';
is $r->rates, $data->{rates}, 'rates';


my $module = 'FixerIO::Endpoint::Timeseries';
my $timeseriesResponse = "${module}::Response";

my $harrysKey='5c133d07d477c48aaefaf549082d7126';

require_ok $module
    or BAIL_OUT
"Does fixer.t pass all tests?
Is the \$accessKey defined?
Is there access to the internet?";

my $time = new_ok $module => [$harrysKey];

is_deeply $time->start_date('2012-05-01')->end_date('2012-05-03'), $time, "Chaining method calls.";

is  "$time",
    'http://data.fixer.io/api/timeseries?access_key='.$harrysKey.'&start_date=2012-05-01&end_date=2012-05-03',
    'Endpoint URL is correct.';

my $newBase = 'USD';
$time->base($newBase);
is  "$time",
    'http://data.fixer.io/api/timeseries?access_key='.$harrysKey
                                        .'&start_date=2012-05-01'
					.'&end_date=2012-05-03'
                                        .'&base=' . $newBase,
    'set base (currency) URL is correct.';

$time->base();
is  "$time",
    'http://data.fixer.io/api/timeseries?access_key='.$harrysKey
                                        .'&start_date=2012-05-01'
					.'&end_date=2012-05-03',
    'reset base to default URL is correct.';

my @mySymbols = qw(USD GBP JPY BTC);
$time->symbols(@mySymbols);
is  "$time",
    'http://data.fixer.io/api/timeseries?access_key='.$harrysKey
                                        .'&start_date=2012-05-01'
					.'&end_date=2012-05-03'
                                        .'&symbols=' . join(',', @mySymbols),
    'set symbols URL is correct.';

$time->symbols();
is  "$time",
    'http://data.fixer.io/api/timeseries?access_key='.$harrysKey
                                        .'&start_date=2012-05-01'
					.'&end_date=2012-05-03',
    'reset symbols empty is correct.';

can_ok $time, 'get_response';
$time->symbols(@mySymbols);

SKIP: {
    skip "This end point is not available to my free account.", 4 if 1;

    local $TODO = "my access key is free, this endpoint is not free";

    my $response = $time->get_response;
    isa_ok $response, $timeseriesResponse, "\$response is a $timeseriesResponse";

    my $save = $response;
    $response = $time->get_response;

    is $response, $save, 'eTag is working';

    $response = $time->force_new->get_response;

    isnt $response, $save, 'force_new is working';

    is_deeply $response, $save, 'The data are the same, see?';
}

done_testing();
exit;
