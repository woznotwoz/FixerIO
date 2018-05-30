#!perl

use strict;
use warnings;
use Test::More;

use FixerIO::Endpoint::Convert;

my $data = {
    success => 1,
    query => {
        from => "GBP",
        to => "JPY",
        amount => 25
    },
    info => {
        timestamp => 1519328414,
        rate => 148.972231
    },
    historical => "",
    date => "2018-02-22",
    result => 3724.305775
};

my $r = FixerIO::Endpoint::Convert::Response->new($data);

is $r->success, $data->{success}, 'success';
is $r->from, $data->{query}{from}, 'from';
is $r->to, $data->{query}{to}, 'to';
is $r->amount, $data->{query}{amount}, 'amount';
is $r->timestamp, $data->{info}{timestamp}, 'timestamp';
is $r->rate, $data->{info}{rate}, 'rate';
is $r->historical, $data->{historical}, 'historical';
is $r->date, $data->{date}, 'date';
is $r->result, $data->{result}, 'result';
is "$r", $data->{result}, 'result via overload';
#is "$r", $$r, 'result via overload';


my $module = 'FixerIO::Endpoint::Convert';
my $convertResponse = "${module}::Response";

my $harrysKey='5c133d07d477c48aaefaf549082d7126';

# my $convert = new_ok $convertRequest => [ {
#                                             api_key => $harrysKey,
#                                             from => 'EUR',
#                                             to => 'USD',
#                                             amount => 25.00,
#                                             date => '2010-06-27'
#                                         } ];

my $to = 'USD';
my $from = 'EUR';
my $amount = '25.00';
my $dateParam = '2005-08-02';

my $convert = new_ok $module => [ { access_key => $harrysKey,
                                          from => $from,
                                            to => $to,
                                        amount => $amount,
                                          date => $dateParam} ];

$convert = new_ok $module => [$harrysKey, $to, $from, $amount, $dateParam];

$convert = new_ok $module => [$harrysKey];
is ''.$convert->to($to)->from($from)->amount($amount), "$convert", 'chaining works';

is  "$convert",
    'http://data.fixer.io/api/convert' . '?access_key='.$harrysKey
                                       . '&from='.$from
                                       . '&to='.$to
                                       . '&amount='.$amount,
    'Endpoint URL is correct.';

$convert->date($dateParam);
is  "$convert",
    'http://data.fixer.io/api/convert' . '?access_key='.$harrysKey
                                       . '&from='.$from
                                       . '&to='.$to
                                       . '&amount='.$amount
                                       . '&date=' . $dateParam,
    'set base (currency) URL is correct.';

$convert->date();
is  "$convert",
    'http://data.fixer.io/api/convert' . '?access_key='.$harrysKey
                                       . '&from='.$from
                                       . '&to='.$to
                                       . '&amount='.$amount,
    'reset base to default URL is correct.';

can_ok $convert, 'get_response';

SKIP: {
    skip "This end point is not available to my free account.", 4 if 1;

    my $response = $convert->get_response;
    isa_ok $response, $convertResponse, "\$response is a $convertResponse";

    my $save = $response;
    $response = $convert->get_response;

    is $response, $save, 'eTag is working';

    $response = $convert->force_new->get_response;

    isnt $response, $save, 'force_new is working';

    is_deeply $response, $save, 'The data are the same, see?';
}

done_testing();
exit;
