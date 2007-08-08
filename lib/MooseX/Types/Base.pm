package MooseX::Types::Base;

=head1 NAME

MooseX::Types::Base - Type library base class

=cut

#use warnings;
#use strict;

use Sub::Install                    qw( install_sub );
use Carp::Clan                      qw( ^MooseX::Types );
use MooseX::Types::Util             qw( filter_tags );
use Moose::Util::TypeConstraints;
use Moose;

use namespace::clean -except => [qw( meta )];

=head1 DESCRIPTION

You normally won't need to interact with this class by yourself. It is
merely a collection of functionality that type libraries need to 
interact with moose and the rest of the L<MooseX::Types> module.

=cut

my $UndefMsg = q{Unable to find type '%s' in library '%s'};

=head1 METHODS

=cut

=head2 import

Provides the import mechanism for your library. See 
L<MooseX::Types/"LIBRARY USAGE"> for syntax details on this.

=cut

sub import {
    my ($class, @args) = @_;

    # separate tags from types and possible options
    my ($options) = grep { ref $_ eq 'HASH' } @args;
    my ($tags, $types) 
      = filter_tags
        grep { ref $_ ne 'HASH' }
        @args;
    my $callee = ($options && $options->{ -into } || scalar(caller));

    # :all replaces types with full list
    @$types = $class->type_names if $tags->{all};

  TYPE:
    # export all requested types
    for my $type (@$types) {
        $class->export_type_into(
            $callee, 
            $type, 
            sprintf($UndefMsg, $type, $class),
            ($options ? %$options : ()),
        );
    }
    return 1;
}

=head2 export_type_into

Exports one specific type into a target package.

=cut

sub export_type_into {
    my ($class, $target, $type, $undef_msg, %args) = @_;
    
    # the real type name and its type object
    my $full = $class->get_type($type)
        or croak "No fully qualified type name stored for '$type'";
    my $tobj = find_type_constraint($full);

    # a possible wrapper around library functionality
    my $wrap = $args{ -wrapper } || 'MooseX::Types';

    # install Type name constant
    install_sub({
        code => $wrap->type_export_generator($type, $full),
        into => $target,
        as   => $type,
    });

    # install is_Type test function
    install_sub({
        code => $wrap->check_export_generator($type, $full, $undef_msg),
        into => $target,
        as   => "is_$type",
    });

    # only install to_Type coercion handler if type can coerce
    # or if we want to provide them anyway, e.g. declarations
    if ($args{ -full } or $tobj and $tobj->has_coercion) {
    
        # install to_Type coercion handler
        install_sub({
            code => $wrap->coercion_export_generator($type, $full, $undef_msg),
            into => $target,
            as   => "to_$type",
        });
    }

    return 1;
}

=head2 get_type

This returns a type from the library's store by its name.

=cut

sub get_type {
    my ($class, $type) = @_;

    # useful message if the type couldn't be found
    croak "Unknown type '$type' in library '$class'"
        unless $class->has_type($type);

    # return real name of the type
    return $class->type_storage->{ $type };
}

=head2 type_names

Returns a list of all known types by their name.

=cut

sub type_names {
    my ($class) = @_;

    # return short names of all stored types
    return keys %{ $class->type_storage };
}

=head2 add_type

Adds a new type to the library.

=cut

sub add_type {
    my ($class, $type) = @_;

    # store type with library prefix as real name
    $class->type_storage->{ $type } = "${class}::${type}";
}

=head2 has_type

Returns true or false depending on if this library knows a type by that
name.

=cut

sub has_type {
    my ($class, $type) = @_;

    # check if we stored a type under that name
    return ! ! $class->type_storage->{ $type };
}

=head2 type_storage

Returns the library's type storage hash reference. You shouldn't use this
method directly unless you know what you are doing. It is not an internal
method because overriding it makes virtual libraries very easy.

=cut

sub type_storage {
    my ($class) = @_;

    # return a reference to the storage in ourself
    {   no strict 'refs';
        return \%{ $class . '::__MOOSEX_TYPELIBRARY_STORAGE' };
    }
}

=head1 SEE ALSO

L<MooseX::Types::Moose>

=head1 AUTHOR AND COPYRIGHT

Robert 'phaylon' Sedlacek C<E<lt>rs@474.atE<gt>>, with many thanks to
the C<#moose> cabal on C<irc.perl.org>.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;
