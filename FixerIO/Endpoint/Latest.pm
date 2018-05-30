use strict;
use warnings;

package FixerIO::Endpoint::Latest
{
    use parent qw(FixerIO::Endpoint);
    use overload '""' => 'latest_endpoint_url';

    use constant {
        API_KEY => 'access-key',
        BASE    => 'base',
        SYMBOLS => 'symbols'
    };

    sub latest_endpoint_url {
        my $self = shift;

        return  'http://data.fixer.io/api/' . 'latest'
                .$self-> access_key (          $self->{API_KEY})
                .$self->   optional ( BASE,    $self->{BASE})
                .$self->   optional ( SYMBOLS, $self->{SYMBOLS});
    }

    sub new {
        my $class = shift;
        my $accessKey = shift;
        return bless {API_KEY => $accessKey}, $class;
    }

    #### This name would clash with &PARENT::symbols.
    sub symbols {
        my $self=shift;
        $self->{SYMBOLS} = [@_];
        return $self;
    }

    sub base {
        my $self=shift;
        $self->{BASE} = shift;
        return $self;
    }
}

package FixerIO::Endpoint::Latest::Response
{
    my $data={}; # This is for data hiding

    sub new {
        my $class = shift;
        $data  = shift;
        return bless $data->{rates}, $class;
    }

    sub success {
        return 1;
    }

    sub timestamp {
        return $data->{timestamp};
    }

    sub base {
        return $data->{base};
    }

    sub date {
        return $data->{date};
    }

    sub rates {
        my $self=shift;
        my %data = %{$self};
        return wantarray ? %data : \%data;
    }
}

1;
