use strict;
use warnings;

package FixerIO::Endpoint::Timeseries
{
    use parent qw(FixerIO::Endpoint);
    use overload '""' => 'timeseries_endpoint_url';

    use constant {
        API_KEY    => 'access_key',
        START_DATE => 'start_date',
        END_DATE   => 'end_date',
        BASE       => 'base',
        SYMBOLS    => 'symbols'
    };

    sub timeseries_endpoint_url {
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

package FixerIO::Endpoint::Timeseries::Response
{
    use base qw(Class::Accessor);
    FixerIO::Endpoint::Timeseries::Response->mk_accessors(
        qw(
            success
            timeseries
            start_date
            end_date
            base
            rates
        ));

   #  Sample Response:
   #  {
   #    "success": true,
   #    "timeseries": true,
   #    "start_date": "2012-05-01",
   #    "end_date": "2012-05-03",
   #    "base": "EUR",
   #    "rates": {
   #        "2012-05-01":{
   #          "USD": 1.322891,
   #          "AUD": 1.278047,
   #          "CAD": 1.302303
   #        },
   #        "2012-05-02": {
   #          "USD": 1.315066,
   #          "AUD": 1.274202,
   #          "CAD": 1.299083
   #        },
   #        "2012-05-03": {
   #          "USD": 1.314491,
   #          "AUD": 1.280135,
   #          "CAD": 1.296868
   #        },
   #        [...]
   #    }
   #  }
}

1;
