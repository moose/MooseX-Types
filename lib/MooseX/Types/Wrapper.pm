package MooseX::Types::Wrapper;
#use warnings;
#use strict;
#use base 'MooseX::Types';

use Carp    qw( croak );
use Class::Inspector;
use Moose;
use namespace::clean;

extends 'MooseX::Types';

sub import {
    my ($class, @args) = @_;
    my %libraries = @args == 1 ? (Moose => $args[0]) : @args;

    for my $l (keys %libraries) {

        croak qq($class expects an array reference as import spec)
            unless ref $libraries{ $l } eq 'ARRAY';

        my $library_class 
          = ($l eq 'Moose' ? 'MooseX::Types::Moose' : $l );
        require Class::Inspector->filename($library_class)
            unless Class::Inspector->loaded($library_class);

        $library_class->import( @{ $libraries{ $l } }, { 
            -into    => scalar(caller),
            -wrapper => $class,
        });
    }
    return 1;
}

1;
