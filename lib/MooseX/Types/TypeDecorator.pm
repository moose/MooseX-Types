package MooseX::Types::TypeDecorator;

use strict;
use warnings;

use Carp::Clan qw( ^MooseX::Types );
use Moose::Util::TypeConstraints ();
use Moose::Meta::TypeConstraint::Union;

use overload(
    '""' => sub {
        return shift->__type_constraint->name; 
    },
    '|' => sub {
        
        ## It's kind of ugly that we need to know about Union Types, but this
        ## is needed for syntax compatibility.  Maybe someday we'll all just do
        ## Or[Str,Str,Int]
        
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
    my $class = shift @_;
    if(my $arg = shift @_) {
        if(ref $arg && $arg->isa('Moose::Meta::TypeConstraint')) {
            return bless {'__type_constraint'=>$arg}, $class;
        } elsif(ref $arg && $arg->isa('MooseX::Types::UndefinedType')) {
            ## stub in case we'll need to handle these types differently
            return bless {'__type_constraint'=>$arg}, $class;
        } elsif(ref $arg) {
            croak "Argument must be ->isa('Moose::Meta::TypeConstraint') or ->isa('MooseX::Types::UndefinedType'), not ". ref $arg;
        } else {
            croak "Argument cannot be '$arg'";
        }
    } else {
        croak "This method [new] requires a single argument of 'arg'.";        
    }
}

=head __type_constraint ($type_constraint)

Set/Get the type_constraint.

=cut

sub __type_constraint {
    my $self = shift @_;
    if(defined(my $tc = shift @_)) {
        $self->{__type_constraint} = $tc;
    }
    return $self->{__type_constraint};
}

=head2 isa

handle $self->isa since AUTOLOAD can't.

=cut

sub isa {
    my ($self, $target) = @_; 
    if(defined $target) {
        return $self->__type_constraint->isa($target);
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
        return $self->__type_constraint->can($target);
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
    my ($self, @args) = @_;
    my ($method) = (our $AUTOLOAD =~ /([^:]+)$/);
    if($self->__type_constraint->can($method)) {
        return $self->__type_constraint->$method(@args);
    } else {
        croak "Method '$method' is not supported";   
    }
}

=head1 AUTHOR AND COPYRIGHT

John Napiorkowski (jnapiorkowski) <jjnapiork@cpan.org>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;
