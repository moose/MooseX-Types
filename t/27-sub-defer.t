use strict;
use warnings;

use Test::More 0.88;
use if $ENV{AUTHOR_TESTING}, 'Test::Warnings';

use Test::Fatal;
use B::Deparse;
use MooseX::Types::Moose qw( Int );
use Sub::Defer qw( undefer_all );

like(
    B::Deparse->new->coderef2text( \&is_Int ),
    qr/package Sub::Defer/,
    'is_Int sub has not yet been undeferred'
);
is(
    exception { undefer_all() },
    undef,
    'Sub::Defer::undefer_all works with subs exported by MooseX::Types'
);

{
    package MyTypes;

    use MooseX::Types -declare => ['Unused'];
}

is(
    exception { undefer_all() },
    undef,
    'Sub::Defer::undefer_all does not throw an exception with unused type declaration'
);

done_testing();
