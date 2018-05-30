use strict;
use warnings;

package FixerIO::Endpoint::Convert
{
    use overload '""' => 'convert_endpoint_url';
    use base qw(FixerIO::Endpoint);

    use constant {
        API_KEY => 'access-key',
        FROM    => 'from',
        TO      => 'to',
        AMOUNT  => 'amount',
        DATE    => 'date'
    };

    sub convert_endpoint_url {
        my $self = shift;

        return  'http://data.fixer.io/api/' . 'convert'
                . $self-> access_key (         $self->{API_KEY})
                . $self->   required ( FROM,   $self->{FROM})
                . $self->   required ( TO,     $self->{TO})
                . $self->   required ( AMOUNT, $self->{AMOUNT})
                . $self->   optional ( DATE,   $self->{DATE});
    }

    sub new {
        my $class = shift;
        my $accessKey = shift;
        return bless {API_KEY => $accessKey}, $class;
    }

    sub from {
        my $self=shift;
        $self->{FROM} = shift;
        return $self;
    }

    sub to {
        my $self=shift;
        $self->{TO} = shift;
        return $self;
    }

    sub amount {
        my $self=shift;
        $self->{AMOUNT} = shift;
        return $self;
    }

    sub date {
        my $self=shift;
        $self->{DATE} = shift;
        return $self;
    }
}

package FixerIO::Endpoint::Convert::Response
{
    use overload '""' => 'as_string';

    use base qw(Class::Accessor);
    FixerIO::Endpoint::Convert::Response->mk_accessors(
        qw(
            success
            from
            to
            amount
            timestamp
            rate
            historical
            date
            result
        ));

#    sub success {
#        return 1;
#    }
#
    sub from {
        return $_[0]->{query}{from}
    }

    sub to {
        return $_[0]->{query}{to}
    }

    sub amount {
        return $_[0]->{query}{amount}
    }

    sub timestamp {
        return $_[0]->{info}{timestamp};
    }

    sub rate {
        return $_[0]->{info}{rate};
    }

#    sub historical {
#        return $data->{historical};
#    }
#
#    sub date {
#        return $data->{date};
#    }
#
#    sub result {
#        return $_[0]->{result};
#    }

    sub as_string {
        my $self=shift;
        return $self->result;
    }
}

1;
