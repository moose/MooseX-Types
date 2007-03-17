#!/usr/bin/env perl
use warnings;
use strict;

use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib";
use MooseX::TypeLibrary::Moose ':all';

my @types = MooseX::TypeLibrary::Moose->type_names;

plan tests => @types * 3;

for my $t (@types) {
    ok my $code = __PACKAGE__->can($t), "$t() was exported";
    is $code->(), $t, "$t() returns '$t'";
    ok __PACKAGE__->can("is_$t"), "is_$t() was exported";
}

