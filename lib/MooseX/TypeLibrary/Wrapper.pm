package MooseX::TypeLibrary::Wrapper;
use warnings;
use strict;
use base 'MooseX::TypeLibrary';

use Carp    qw( croak );
use Class::Inspector;
use namespace::clean;

sub import {
    my ($class, @args) = @_;
    my %libraries = @args == 1 ? (Moose => $args[0]) : @args;

    for my $l (keys %libraries) {

        croak qq($class expects an array reference as import spec)
            unless ref $libraries{ $l } eq 'ARRAY';

        my $library_class 
          = ($l eq 'Moose' ? 'MooseX::TypeLibrary::Moose' : $l );
        require Class::Inspector->filename($library_class)
            unless Class::Inspector->loaded($library_class);

        $library_class->import( 
            @{ $libraries{ $l } }, 
            { -into => scalar(caller) } 
        );
    }
    return 1;
}

1;
