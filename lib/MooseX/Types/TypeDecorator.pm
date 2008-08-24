package MooseX::Types::TypeDecorator;

use Moose;
use Moose::Util::TypeConstraints ();
use Moose::Meta::TypeConstraint ();

use overload(
    '""' => sub {
        shift->type_constraint->name;  
    },
    '&' => sub {warn 'got code context'},
);

=head1 NAME

MooseX::Types::TypeDecorator - More flexible access to a Type Constraint

=head1 DESCRIPTION

This is a decorator object that contains an underlying type constraint.  We use
this to control access to the type constraint and to add some features.

=head1 TYPES

The following types are defined in this class.

=head2 Moose::Meta::TypeConstraint

Used to make sure we can properly validate incoming type constraints.

=cut

Moose::Util::TypeConstraints::class_type 'Moose::Meta::TypeConstraint';

=head2 MooseX::Types::UndefinedType

Used since sometimes our constraint is an unknown type.

=cut

Moose::Util::TypeConstraints::class_type 'MooseX::Types::UndefinedType';

=head1 ATTRIBUTES

This class defines the following attributes

=head2 type_constraint

This is the type constraint that we are delegating

=cut

has 'type_constraint' => (
    is=>'ro',
    isa=>'Moose::Meta::TypeConstraint|MooseX::Types::UndefinedType',
    handles=>[
        grep {
            $_ ne 'meta' && $_ ne '(""';
        } map {
            $_->{name};
        } Moose::Meta::TypeConstraint->meta->compute_all_applicable_methods,
    ],
);

=head1 METHODS

This class defines the following methods.

=head1 AUTHOR AND COPYRIGHT

John Napiorkowski (jnapiorkowski) <jjnapiork@cpan.org>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;
