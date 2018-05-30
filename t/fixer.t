#!perl

use strict;
use warnings;
use Test::More;
use Data::Dumper;

my $module = 'FixerIO';
my $symbolsRequest = 'FixerIO::Endpoint::Symbols';
my $symbolsResponse = 'FixerIO::Endpoint::Symbols::Response';

ok -e "${module}.pm", "$module is findable" or BAIL_OUT("Can't find $module.pm.");

eval "use $module";
ok !$@, "use $module" or BAIL_OUT("Does $module.pm compile? Does it end with 1; ?");

my $harrysKey='5c133d07d477c48aaefaf549082d7126';

my $fixer = new_ok $module => [$harrysKey];
# Maybe new could take a second parameter that asserts a subscription level?

my $request = $fixer->symbols;
isa_ok $request, $symbolsRequest;

my $response = $request->get_response();
isa_ok $response, $symbolsResponse;

done_testing();
exit;
__END__

use FindBin;
my $dir;
BEGIN { $dir = $FindBin::Bin . '/' };
use lib $dir;
ok -e "${dir}${module}.pm", "$module is findable" or BAIL_OUT("Can't find $module.pm.");


can_ok $fixer, qw( get_base_currency get_latest_url set_base_currency
                   get_api_key       get_base_url   set_ssl_connection
		   set_symbols       get_symbols    symbols
		   latest            implemented_endpoints);

my @endPoints = FixerIO::implemented_endpoints(); # qw( symbols latest )

is $fixer->get_api_key, $harrysKey, "Object returns it's own access_key.";

is $fixer->get_base_url, 'http://data.fixer.io/api/', "Base URL is the one from the documentation.";

ok $fixer-> set_ssl_connection(1)->get_base_url =~ /https:/, 'set_ssl_connection(truthy) sets object to use SSL.';
ok $fixer-> set_ssl_connection(0)->get_base_url =~ /http:/, 'set_ssl_connection(falsy) sets object to not use SSL.';
ok $fixer-> set_ssl_connection(1)->get_base_url =~ /https:/, 'set_ssl_connection(truthy), again, to set up the next test.';
ok $fixer-> set_ssl_connection()->get_base_url =~ /http:/, 'set_ssl_connection() w/ no parameter is same as falsey parameter.';

is $fixer->get_base_currency(), 'EUR', "This should be default, since we haven't set it.";

my $newBase = 'USD';
is $fixer-> set_base_currency($newBase), $fixer, "'set_' something returns self";
is $fixer-> get_base_currency(), $newBase, "Now the base currency is $newBase.";
is $fixer-> set_base_currency ($newBase)->get_latest_url, $fixer->get_base_url.'latest'."?access_key=$harrysKey"."&base=$newBase", '"latest" request with base currency';
is $fixer-> set_base_currency(), $fixer, "something falsey returns self, ...";
is $fixer-> get_base_currency(), 'EUR', "Now the base currency is the default, again.";
is $fixer->get_latest_url, $fixer->get_base_url.'latest'."?access_key=$harrysKey", 'The most basic "latest" request';


exit;

