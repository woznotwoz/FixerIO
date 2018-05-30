use strict;
use warnings;

package FixerIO::Endpoint::Symbols
{
    use parent qw(FixerIO::Endpoint);
    use overload '""' => 'symbols_endpoint_url';

    use constant {
        API_KEY => 'access-key',
    };

    sub symbols_endpoint_url {
	my $self=shift;

	return 'http://data.fixer.io/api/' . 'symbols'
	       .$self-> access_key ($self->{API_KEY})
    }

    sub new {
	my $class = shift;
	my $accessKey = shift;
	return bless {API_KEY => $accessKey}, $class;
    }
};

package FixerIO::Endpoint::Symbols::Response
{
    sub new {
	my $class = shift;
	my $data  = shift;
	return bless $data->{symbols}, $class;
    }

    sub success {
	return 1;
    }

    sub symbols {
	my $self=shift;
	my %data = %{$self};
	return wantarray ? %data : \%data;
    }
}

1;
