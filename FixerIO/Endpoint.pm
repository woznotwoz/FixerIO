package FixerIO::Endpoint;
# Harry's access_key : '5c133d07d477c48aaefaf549082d7126';

use strict;
use warnings;
use LWP::UserAgent;
use JSON::PP 'decode_json';
use Data::Dumper;
use Carp;

use FixerIO::Endpoint::Error;

my $etags={};
my $ua;

sub access_key {
    my $self=shift;
    croak "Access_key is required, but not found." if not defined $_[0];
    return  "?access_key=" . shift;
}

sub required {
    my $self=shift;
    croak "Missing value for required parameter, '$_[0]'" if not defined $_[1];
    return  '&' . shift . '=' . shift;
}

sub optional {
    my $self=shift;
    my $name=shift;
    my $value = shift;
    if (defined $value) {
        if (ref $value eq 'ARRAY') {
            my $multivalue = join ',', @{$value};
            return  "\&${name}=$multivalue" if $multivalue;
        } else {
            return "\&${name}=${value}";
        }
    }
    return '';
}

sub force_new {
    my $caller=shift;

    delete $etags->{$caller};

    return $caller;
}

sub userAgent {
    return $ua if defined $ua;

    $ua = LWP::UserAgent->new;
    $ua->agent("FixerIO-LWP/0.1 "); # Is there a better agent string?
    return $ua;
}

sub get_response {
    my $caller=shift;

    my $url  = "$caller"; # This allows me to call this method with a string or with an overloaded object.
    my $etag = $etags->{$url}{etag};
    my $date = $etags->{$url}{date};

    my $req = HTTP::Request->new(GET => $url);
    $req->header( 'If-None-Match',     $etag) if (defined $etag);
    $req->header( 'If-Modified-Since', $date) if (defined $date);

    my $httpResponse = userAgent()->request($req);

    $etags->{$url}{etag} = $httpResponse->header('etag');
    $etags->{$url}{date} = $httpResponse->header('date');

    # Check the outcome of the response
    if ($httpResponse->is_success) {
        my $apiResponse = decode_json( $httpResponse->decoded_content ); # decode_json could die() here.
	if ( $apiResponse->{success} ) {
	    my $r;
            for ($url) {
                /convert\?/  && ($r = FixerIO::Endpoint::Convert::Response->new($apiResponse));
                /fluctuation\?/  && ($r = FixerIO::Endpoint::Fluctuation::Response->new($apiResponse));
                /\d{4}-\d{2}-\d{2}\?/  && ($r = FixerIO::Endpoint::Historical::Response->new($apiResponse));
                /latest\?/  && ($r = FixerIO::Endpoint::Latest::Response->new($apiResponse));
                /symbols\?/ && ($r = FixerIO::Endpoint::Symbols::Response->new($apiResponse));
                /timeseries\?/ && ($r = FixerIO::Endpoint::Timeseries::Response->new($apiResponse));
            }
	    $etags->{$url}{response} = $r;
	    return $r;
	}
        return FixerIO::Endpoint::Error->new($apiResponse);
    } elsif ($httpResponse->code() eq '304') { # This is the etag response.
	return $etags->{$url}{response};
    }
    warn "HTTP Response Code is " . $httpResponse->code() . "\n";
    return undef; # Assume this is an HTTP error.
	          # Not handling HTTP errors at this point
}

1;
