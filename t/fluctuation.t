#!perl

use strict;
use warnings;
use Test::More;

use FixerIO::Endpoint::Fluctuation;

my $data = {
                success =>1,
                fluctuation =>1,
                start_date =>"2018-02-25",
                end_date =>"2018-02-26",
                base =>"EUR",
                rates =>{
                    USD =>{
                        start_rate =>1.228952,
                        end_rate =>1.232735,
                        change =>0.0038,
                        change_pct =>0.3078
                    },
                    JPY =>{
                        start_rate =>131.587611,
                        end_rate =>131.651142,
                        change =>0.0635,
                        change_pct =>0.0483
                    }
                }
            };

my $r = FixerIO::Endpoint::Fluctuation::Response->new($data);

is $r->success, $data->{success}, 'success';
is $r->fluctuation, $data->{fluctuation}, 'fluctuation';
is $r->start_date, $data->{start_date}, 'start_date';
is $r->end_date, $data->{end_date}, 'end_date';
is $r->base, $data->{base}, 'base';
is $r->rates, $data->{rates}, 'rates';


my $module = 'FixerIO::Endpoint::Fluctuation';
my $fluctuationResponse = "${module}::Response";

my $harrysKey='5c133d07d477c48aaefaf549082d7126';

require_ok $module
    or BAIL_OUT
"Does fixer.t pass all tests?
Is the \$accessKey defined?
Is there access to the internet?";

my $flux = new_ok $module => [$harrysKey];

my $startDate = '2012-05-01';
my $endDate = '2012-05-03';

is_deeply $flux->start_date($startDate)->end_date($endDate), $flux, "Chaining method calls.";

is  "$flux",
    'http://data.fixer.io/api/timeseries?access_key='.$harrysKey
                                        .'&start_date='.$startDate
                                        .'&end_date='.$endDate,
    'Endpoint URL is correct.';

my $newBase = 'USD';
$flux->base($newBase);
is  "$flux",
    'http://data.fixer.io/api/timeseries?access_key='.$harrysKey
                                        .'&start_date='.$startDate
                                        .'&end_date='.$endDate
                                        .'&base=' . $newBase,
    'set base (currency) URL is correct.';

$flux->base();
is  "$flux",
    'http://data.fixer.io/api/timeseries?access_key='.$harrysKey
                                        .'&start_date='.$startDate
                                        .'&end_date='.$endDate,
    'reset base to default URL is correct.';

my @mySymbols = qw(USD GBP JPY BTC);
$flux->symbols(@mySymbols);
is  "$flux",
    'http://data.fixer.io/api/timeseries?access_key='.$harrysKey
                                        .'&start_date='.$startDate
                                        .'&end_date='.$endDate
                                        .'&symbols=' . join(',', @mySymbols),
    'set symbols URL is correct.';

$flux->symbols();
is  "$flux",
    'http://data.fixer.io/api/timeseries?access_key='.$harrysKey
                                        .'&start_date='.$startDate
                                        .'&end_date='.$endDate,
    'reset symbols empty is correct.';

can_ok $flux, 'get_response';
$flux->symbols(@mySymbols);

SKIP: {
    skip "This end point is not available to my free account.", 4 if 1;

    local $TODO = "my access key is free, this endpoint is not free";

    my $response = $flux->get_response;
    isa_ok $response, $fluctuationResponse, "\$response is a $fluctuationResponse";

    my $save = $response;
    $response = $flux->get_response;

    is $response, $save, 'eTag is working';

    $response = $flux->force_new->get_response;

    isnt $response, $save, 'force_new is working';

    is_deeply $response, $save, 'The data are the same, see?';
}

done_testing();
exit;
