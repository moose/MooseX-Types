#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";   
 
use Test::More tests => 4;

BEGIN { use_ok 'Combined', qw/Foo2Alias MTFNPY NonEmptyStr/ }

# test that a type from TestLibrary was exported
ok Foo2Alias;

# test that a type from TestLibrary2 was exported
ok MTFNPY;

is NonEmptyStr->name, 'TestLibrary2::NonEmptyStr',
    'precedence for conflicting types is correct';
