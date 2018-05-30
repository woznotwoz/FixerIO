use strict;
use warnings;

package FixerIO::Endpoint::Fluctuation
{
    use parent qw(FixerIO::Endpoint);
    use overload '""' => 'fluctuation_endpoint_url';

    use constant {
        API_KEY    => 'access_key',
        START_DATE => 'start_date',
        END_DATE   => 'end_date',
        BASE       => 'base',
        SYMBOLS    => 'symbols'
    };

    sub fluctuation_endpoint_url {
        my $self = shift;

        return  'http://data.fixer.io/api/' . 'timeseries'
                .$self-> access_key (             $self->{API_KEY})
                .$self->   required ( START_DATE, $self->{START_DATE})
                .$self->   required ( END_DATE,   $self->{END_DATE})
                .$self->   optional ( BASE,       $self->{BASE})
                .$self->   optional ( SYMBOLS,    $self->{SYMBOLS});
    }

    sub new {
        my $class = shift;
        my $accessKey = shift;
        return bless {API_KEY => $accessKey}, $class;
    }

    sub start_date {
        my $self=shift;
        $self->{START_DATE} = shift;
        return $self;
    }

    sub end_date {
        my $self=shift;
        $self->{END_DATE} = shift;
        return $self;
    }

    sub base {
        my $self=shift;
        $self->{BASE} = shift;
        return $self;
    }

    sub symbols {
        my $self=shift;
        $self->{SYMBOLS} = [@_];
        return $self;
    }

    #  Above subs may be chained, which makes for nice looking, short scripts and one liners.
    #  Additionally, I want an expression like, $self->symbols(), to make the value an empty list, not return the existing list.
    #  Theoretically, anyways.
    #  So, we need a sub like this one.
    sub what_is {
        my $self = shift;
        my $name = shift;

        for ($name) {
            /API_KEY/    && last;
            /START_DATE/ && last;
            /END_DATE/   && last;
            /BASE/       && last;
            /SYMBOLS/    && last;
            
           die ("No such parameter in __PACKAGE__."); # If I had a seperate sub for each getter, there would be a die() if you called a sub that didn't exist.
        }

        my $value = $self->{$name};
        if (ref $value eq 'ARRAY') {
            return wantarray ? @{$value} : $value;
        }
        return $value;
    }
}

package FixerIO::Endpoint::Fluctuation::Response
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

    sub fluctuation {
        return $data->{fluctuation}
    }

    sub start_date {
        return $data->{start_date}
    }

    sub end_date {
        return $data->{end_date}
    }

    sub base {
        return $data->{base}
    }

    sub rates {
        return $data->{rates}
    }
}

1;
