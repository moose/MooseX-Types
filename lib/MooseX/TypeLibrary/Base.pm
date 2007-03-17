package MooseX::TypeLibrary::Base;
use warnings;
use strict;

#use Smart::Comments;
use Sub::Install    qw( install_sub );
use Carp            qw( croak );
use Moose::Util::TypeConstraints;
use namespace::clean;

my $UndefMsg = q{Unable to find type '%s' in library '%s'};

sub import {
    my ($class, @types) = @_;

    # flatten out tags
    @types = map { $_ eq ':all' ? $class->type_names : $_ } @types;

  TYPE:
    # export all requested types
    for my $type (@types) {
        $class->export_type_into(
            scalar(caller), $type, sprintf $UndefMsg, $type, $class );
    }
    return 1;
}

sub export_type_into {
    my ($class, $target, $type, $undef_msg, %args) = @_;
    
    # the real type name and its type object
    my $full = $class->get_type($type);
    my $tobj = find_type_constraint($full);
    ### Exporting: $full

    # install Type name constant
    install_sub({
        code => MooseX::TypeLibrary->type_export_generator($type, $full),
        into => $target,
        as   => $type,
    });

    # install is_Type test function
    install_sub({
        code => MooseX::TypeLibrary
                    ->check_export_generator($type, $full, $undef_msg),
        into => $target,
        as   => "is_$type",
    });

    # only install to_Type coercion handler if type can coerce
    return 1 unless $args{ -full } or $tobj->has_coercion;
    
    # install to_Type coercion handler
    install_sub({
        code => MooseX::TypeLibrary
                    ->coercion_export_generator($type, $full, $undef_msg),
        into => $target,
        as   => "to_$type",
    });

    return 1;
}

sub get_type {
    my ($class, $type) = @_;

    # useful message if the type couldn't be found
    croak "Unknown type '$type' in library '$class'"
        unless $class->has_type($type);

    # return real name of the type
    return $class->type_storage->{ $type };
}

sub type_names {
    my ($class) = @_;

    # return short names of all stored types
    return keys %{ $class->type_storage };
}

sub add_type {
    my ($class, $type) = @_;

    # store type with library prefix as real name
    $class->type_storage->{ $type } = "${class}::${type}";
}

sub has_type {
    my ($class, $type) = @_;

    # check if we stored a type under that name
    return ! ! $class->type_storage->{ $type };
}

sub type_storage {
    my ($class) = @_;

    # return a reference to the storage in ourself
    {   no strict 'refs';
        return \%{ $class . '::__MOOSEX_TYPELIBRARY_STORAGE' };
    }
}

1;
