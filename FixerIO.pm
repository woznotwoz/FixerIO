package FixerIO;
# Harry's access_key : '5c133d07d477c48aaefaf549082d7126';

use strict;
use warnings;
use LWP::UserAgent;
use JSON::PP 'decode_json';
use Data::Dumper;

use FixerIO::Endpoint::Convert;
use FixerIO::Endpoint::Fluctuation;
use FixerIO::Endpoint::Historical;
use FixerIO::Endpoint::Latest;
use FixerIO::Endpoint::Symbols;
use FixerIO::Endpoint::Timeseries;


sub new {
    my $class = shift;
    my $accessKey = shift;

    return undef unless defined $accessKey;

    return bless \$accessKey, $class;
}

sub convert {
    my $self = shift;
    if ($_[0] eq 'HASH') {
        my $params=shift;
        return FixerIO::Convert::Request->new($$self)
               ->from($params->{from})
               ->to($params->{to})
               ->amount($params->{amount})
               ->date($params->{date});
    } else {
    }
        my ($from, $to, $amount, $date) = @_;
        return FixerIO::Convert::Request->new($$self)
               ->from($from)
               ->to($to)
               ->amount($amount)
               ->date($date);
}

sub fluctuation {
    die "Sorry, __SUB__ not implemented, yet.";
}

sub historical {
    my $self=shift;
    my $date=shift;
    return FixerIO::Latest::Request->new($$self, $date);
}

sub latest {
    my $self=shift;
    return FixerIO::Endpoint::Latest->new($$self);
}

sub symbols {
    my $self=shift;
    return FixerIO::Endpoint::Symbols->new($$self);
}

sub timeseries {
    die "Sorry, __SUB__ not implemented, yet.";
}

1;
__DATA__

=encoding utf-8

=head1 NAME

FixerIO.pm - Object oriented access to the fixer.io currency exchange rate API. See, "http://fixer.io/documentation".

=head1 SYNOPSIS

    use FixerIO;

    my $accessKey = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';

    my $availableSymbols = FixerIO->new($accessKey)->api_symbols()->get_response();

    while (my ($symbol, $description) = each %$availableSymbols) {
        print "$symbol - $description\n";
    }


=head1 DESCRIPTION

This is an object oriented Perl library for accessing the API provided
by the http://fixer.io website.

This is a work in progress. It doesn't even have a version number.

The main features of the library are:

=over 3

=item *

Provides seperate modules for accessing each endpoint of the API.
Which may be used on thier own.

=item *

Provides ease of use and options that allow the script writer to efficiently
create a script that helps get work done.

=item *

Supports many features available in the API.

=item *

The Perl code is written as much as possible to be the Perl translation
of the english documentation.  So, you can look at, say, FixerIO::Symbols.pm,
and see that URL for the request is assembled just as it is shown in the
documentation on the site.  The response is the same way.

=item *

Someday, maybe, some command line clients will be included.
But right now it's easy to slap a one liner out, yourself.

=back


=head1 API FEATURES IMPLEMENTED BY THIS LIBRARY


The documentation is at
<URL:https://fixer.io/documentation/>

These features are listed as they appear in the documentation.

=head2 API Key

You have to obtain your own API key from the fixer.io web site.

=head2 Available Endpoints

( Copied from the documentation on the site. )

The Fixer API comes with X API endpoints, each providing a different functionality. Please note that depending on your subscription plan, certain API endpoints may or may not be available.

=over 3

=item *

Latest rates endpoint
Returns real-time exchange rate data for all available or a specific set of currencies.

=item *

Convert endpoint
Allows for conversion of any amount from one currency to another.

=item *

Historical rates endpoint
Returns historical exchange rate data for all available or a specific set of currencies.

=item *

Time-Series data endpoint
Returns daily historical exchange rate data between two specified dates for all available or a specific set of currencies.

=item *

Fluctuation data endpoint
Returns fluctuation data between two specified dates for all available or a specific set of currencies.

=back

=head2 SSL Connection

( not implemented )
Switch from plain HTTP to HTTPS with the ssl_connection() method.

=head2 HTTP Etags

This is implemented and is used automatically.  You can force a
new response from the end point with the force_new() method.

=head2 Potential Errors

When the end point responds with an error object, this library returns
a FixerIO::Error::Response object.

=head2 Specify Symbols

Use the symbols() method to provide a list of the symbols you are
interested in.  The default is that you get them all.

=head2 Changing Base Currency

Use the base() method to provide the base currency. The default is the
Euro, (EUR).

=head2 Endpoints

=head3 Supported Symbols Endpoint

=head3 Latest Rates Endpoint

=head3 Historical Rates Endpoint

=head3 Convert Endpoint

=head3 Time-Series Endpoint

=head3 Fluctuation Endpoint



=head1 OVERVIEW OF CLASSES AND PACKAGES



=head1 MORE DOCUMENTATION


=head1 ENVIRONMENT

The following environment variables are used

=over

=item none, currently

=back

=head1 AUTHOR

Harry Wozniak

=head1 COPYRIGHT

  Copyright 2018, Harry Wozniak

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 AVAILABILITY

CPAN, someday, maybe.

  https://github.com/woznotwoz/FixerIO.pm

=cut
