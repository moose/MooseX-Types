package MooseX::Types::TypeDecorator;

use strict;
use warnings;

use Carp::Clan qw( ^MooseX::Types );
use Moose::Util::TypeConstraints;
use Moose::Meta::TypeConstraint::Union;

use overload(
    '""' => sub {
        shift->type_constraint->name;  
    },
    '|' => sub {
        my @tc = grep {ref $_} @_;
        my $union = Moose::Meta::TypeConstraint::Union->new(type_constraints=>\@tc);
        return Moose::Util::TypeConstraints::register_type_constraint($union);
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
    if(
        $args{type_constraint} && ref($args{type_constraint}) &&
        ($args{type_constraint}->isa('Moose::Meta::TypeConstraint') ||
        $args{type_constraint}->isa('MooseX::Types::UndefinedType'))
    ) {
        return bless \%args, $class;        
    } else {
        croak "The argument 'type_constraint' is not valid.";
    }

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

=head2 isa

handle $self->isa since AUTOLOAD can't.

=cut

sub isa {
    my ($self, $target) = @_;
    if(defined $target) {
        my $isa = $self->type_constraint->isa($target);
        return $isa;
    } else {
        return;
    }
}

=head2 can

handle $self->can since AUTOLOAD can't.

=cut

sub can {
    my ($self, $target) = @_;
    if(defined $target) {
        my $can = $self->type_constraint->can($target);
        return $can;
    } else {
        return;
    }
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
