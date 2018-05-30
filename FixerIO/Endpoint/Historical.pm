use strict;
use warnings;

package FixerIO::Endpoint::Historical
{
    use parent qw(FixerIO::Endpoint);
    use overload '""' => 'historical_endpoint_url';

    use constant {
        API_KEY => 'access_key',
        DATE    => 'date',
        BASE    => 'base',
        SYMBOLS => 'symbols'
    };

    #### big opportunity for data verification and integration of Date object.
    sub historical_endpoint_url {
        my $self = shift;

        return  'http://data.fixer.io/api/'
                . $self->{DATE}
                .$self-> access_key (          $self->{API_KEY})
                .$self->   optional ( BASE,    $self->{BASE})
                .$self->   optional ( SYMBOLS, $self->{SYMBOLS});
    }

    sub new {
        my $class = shift;
        my $accessKey = shift;
        my $historicalDate = shift;

        return bless { API_KEY => $accessKey,
                       DATE    => $historicalDate}, $class;
    }

    #### This name clashes with &PARENT::symbols.
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

package FixerIO::Endpoint::Historical::Response;
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

    sub historical {
        return $data->{historical};
    }

    sub date {
        return $data->{date};
    }

    sub timestamp {
        return $data->{timestamp};
    }

    sub base {
        return $data->{base};
    }

    sub rates {
        my $self=shift;
        my %data = %{$self};
        return wantarray ? %data : \%data;
    }
}

1;
