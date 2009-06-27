#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 1;

my $exception;
{
    package TypeLib;

    use MooseX::Types -declare => [qw( MyUnionType MyStr )];
    use MooseX::Types::Moose qw(Str Item);

    subtype MyUnionType, as Str|'Int';
    subtype MyStr, as Str;

    eval { coerce MyStr, from Item, via {"$_"} };
    $exception = $@;
}

ok !$@, 'types are not mutated by union with a string type';
