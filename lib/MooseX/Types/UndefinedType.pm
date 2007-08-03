package MooseX::Types::UndefinedType;

=head1 NAME

MooseX::Types::UndefinedType - Represents a not yet defined type

=cut

use warnings;
use strict;

use overload '""'     => sub { shift->name },
             fallback => 1;

=head1 DESCRIPTION

Whenever a type handle function (e.g. C<Int()> can't find a type 
constraint under it's full name, it assumes it has not yet been defined.
It will then return an instance of this class, handling only 
stringification, name and possible identification of undefined types.

=head1 METHODS

=head2 new

Takes a full type name as argument and returns an instance of this
class.

=cut

sub new { bless { name => $_[1] }, $_[0] }

=head2 name

Returns the stored type name.

=cut

sub name { $_[0]->{name} }

=head1 SEE ALSO

L<MooseX::Types::Moose>,
L<Moose::Util::TypeConstraints>, 
L<Moose::Meta::TypeConstraint>

=head1 AUTHOR AND COPYRIGHT

Robert 'phaylon' Sedlacek C<E<lt>rs@474.atE<gt>>, with many thanks to
the C<#moose> cabal on C<irc.perl.org>.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as perl itself.

=cut


1;
