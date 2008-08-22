#!/usr/bin/env perl
use warnings;
use strict;

use Test::More tests => 1;
use FindBin;
use lib "$FindBin::Bin/lib";
use DecoratorLibrary qw( ArrayOfInts);

is 1,1, 'ok';

use Data::Dump qw/dump/;
