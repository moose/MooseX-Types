use strict;
use warnings;
package MooseX::Types::Combine;
# ABSTRACT: Combine type libraries for exporting

our $VERSION = '0.47';

use Module::Runtime 'use_module';
use namespace::autoclean;

=head1 SYNOPSIS

    package CombinedTypeLib;

    use base 'MooseX::Types::Combine';

    __PACKAGE__->provide_types_from(qw/TypeLib1 TypeLib2/);

    package UserClass;

    use CombinedTypeLib qw/Type1 Type2 ... /;

=head1 DESCRIPTION

Allows you to export types from multiple type libraries.

Libraries on the right end of the list passed to L</provide_types_from>
take precedence over those on the left in case of conflicts.

=cut

sub import {
    my ($class, @types) = @_;
    my $caller = caller;

    my $where_to_import_to = $caller;
    if (ref $types[0] eq 'HASH') {
        my $extra = shift @types;
        $where_to_import_to = $extra->{-into} if exists $extra->{-into};
    }

    my %types = $class->_provided_types;

    if ( grep { $_ eq ':all' } @types ) {
        $_->import( { -into => $where_to_import_to }, q{:all} )
            for $class->provide_types_from;
        return;
    }

    my %from;
    for my $type (@types) {
        unless ($types{$type}) {
            my @type_libs = $class->provide_types_from;

            die
                "$caller asked for a type ($type) which is not found in any of the"
                . " type libraries (@type_libs) combined by $class\n";
        }

        push @{ $from{ $types{$type} } }, $type;
    }

    $_->import({ -into => $where_to_import_to }, @{ $from{ $_ } })
        for keys %from;
}

=head1 CLASS METHODS

=head2 provide_types_from

Sets or returns a list of type libraries to re-export from.

=cut

sub provide_types_from {
    my ($class, @libs) = @_;

    my $store =
     do { no strict 'refs'; \@{ "${class}::__MOOSEX_TYPELIBRARY_LIBRARIES" } };

    if (@libs) {
        $class->_check_type_lib($_) for @libs;
        @$store = @libs;

        my %types = map {
            my $lib = $_;
            map +( $_ => $lib ), $lib->type_names
        } @libs;

        $class->_provided_types(%types);
    }

    @$store;
}

sub _check_type_lib {
    my ($class, $lib) = @_;

    use_module($lib);

    die "Cannot use $lib in a combined type library, it does not provide any types"
        unless $lib->can('type_names');
}

sub _provided_types {
    my ($class, %types) = @_;

    my $types =
     do { no strict 'refs'; \%{ "${class}::__MOOSEX_TYPELIBRARY_TYPES" } };

    %$types = %types
        if keys %types;

    %$types;
}

sub type_names {
    my ($class) = @_;

    my %types = $class->_provided_types();
    return keys %types;
}

=head1 SEE ALSO

L<MooseX::Types>

=cut

1;
