package MooseX::Types::TypeDecorator;

use strict;
use warnings;

use Moose::Util::TypeConstraints;
use overload(
    '""' => sub {
        shift->type_constraint->name;  
    },
    '|' => sub {
        my @names = grep {$_} map {"$_"} @_;
        ## Don't know why I can't use the array version of this...  If someone
        ## knows would like to hear from you.
        my $names = join('|', @names);
        Moose::Util::TypeConstraints::create_type_constraint_union($names);
    },
);

=head1 NAME

MooseX::Types::TypeDecorator - More flexible access to a Type Constraint

=head1 DESCRIPTION

This is a decorator object that contains an underlying type constraint.  We use
this to control access to the type constraint and to add some features.

=head1 METHODS

This class defines the following methods.

=head2 new

Old school instantiation

=cut

sub new {
    my ($class, %args) = @_;
    return bless \%args, $class;
}

=head type_constraint ($type_constraint)

Set/Get the type_constraint.

=cut

sub type_constraint {
    my $self = shift @_;
    if(defined(my $tc = shift @_)) {
        $self->{type_constraint} = $tc;
    }
    return $self->{type_constraint};
}

=head2 DESTROY

We might need it later

=cut

sub DESTROY {
    return;
}

=head2 AUTOLOAD

Delegate to the decorator targe

=cut

sub AUTOLOAD {
    my ($method) = (our $AUTOLOAD =~ /([^:]+)$/);
    return shift->type_constraint->$method(@_);
}

=head1 AUTHOR AND COPYRIGHT

John Napiorkowski (jnapiorkowski) <jjnapiork@cpan.org>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;
