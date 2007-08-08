#!/usr/bin/env perl
use warnings;
use strict;

use inc::Module::Install 0.67;

name            q{MooseX-Types};
license         q{perl};
author          q{Robert 'phaylon' Sedlacek <rs@474.at>};
all_from        q{lib/MooseX/Types.pm};

build_requires  q{Test::More},                  0.62;
build_requires  q{FindBin},                     0;

requires        q{Moose},                       0.24;
requires        q{Sub::Uplevel},                0.14;
requires        q{Sub::Install},                0.922;
requires        q{namespace::clean},            0.04;
requires        q{Carp},                        0;

system 'pod2text lib/MooseX/Types.pm > README'
    if -e 'MANIFEST.SKIP';

WriteAll;
