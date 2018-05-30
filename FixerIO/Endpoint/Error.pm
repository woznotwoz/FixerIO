package FixerIO::Endpoint::Error;
use strict;
use warnings;
use overload '""' => 'as_string';

sub new {
    my $class = shift;
    my $apiResponse = shift;

    return bless $apiResponse->{error}, $class;
}

sub success {
    return 0;
}

sub code {
    my $self=shift;
    return $self->{code};
}

sub type {
    my $self=shift;
    return $self->{type};
}

sub info {
    my $self=shift;
    return $self->{info};
}

sub as_string {
    my $self=shift;
    'Error #'. $self->code(). ', ['. $self->type(). '], info: '. $self->info();
}

1;
