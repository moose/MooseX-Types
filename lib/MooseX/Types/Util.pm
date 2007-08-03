package MooseX::Types::Util;

=head1 NAME

MooseX::Types::Util - Common utility functions for the module

=cut

use warnings;
use strict;

use base 'Exporter';

=head1 DESCRIPTION

This package the exportable functions that many parts in 
L<MooseX::Types> might need.

=cut

our @EXPORT_OK = qw( filter_tags );

=head1 FUNCTIONS

=head2 filter_tags

Takes a list and returns two references. The first is a hash reference
containing the tags as keys and the number of their appearance as values.
The second is an array reference containing all other elements.

=cut

sub filter_tags {
    my (@list) = @_;
    my (%tags, @other);
    for (@list) {
        if (/^:(.*)$/) {
            $tags{ $1 }++;
            next;
        }
        push @other, $_;
    }
    return \%tags, \@other;
}

=head1 SEE ALSO

L<MooseX::Types::Moose>, L<Exporter>

=head1 AUTHOR AND COPYRIGHT

Robert 'phaylon' Sedlacek C<E<lt>rs@474.atE<gt>>, with many thanks to
the C<#moose> cabal on C<irc.perl.org>.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;
