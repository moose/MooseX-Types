package MooseX::Types::Wrapper;
# ABSTRACT: Wrap exports from a library

our $VERSION = '0.52';

use Carp::Clan      qw( ^MooseX::Types );
use Module::Runtime 'use_module';

use namespace::autoclean;

use parent 'MooseX::Types';

=head1 DESCRIPTION

See L<MooseX::Types/SYNOPSIS> for detailed usage.

=head1 METHODS

=head2 import

=cut

sub import {
    my ($class, @args) = @_;
    my %libraries = @args == 1 ? (Moose => $args[0]) : @args;

    for my $l (keys %libraries) {

        croak qq($class expects an array reference as import spec)
            unless ref $libraries{ $l } eq 'ARRAY';

        my $library_class
          = ($l eq 'Moose' ? 'MooseX::Types::Moose' : $l );
        use_module($library_class);

        $library_class->import({
            -into    => scalar(caller),
            -wrapper => $class,
        }, @{ $libraries{ $l } });
    }
    return 1;
}

1;

=head1 SEE ALSO

L<MooseX::Types>

=cut
