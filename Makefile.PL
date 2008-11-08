#!/usr/bin/env perl
use warnings;
use strict;

use inc::Module::Install 0.67;

name            q{MooseX-Types};
license         q{perl};
author          q{Robert 'phaylon' Sedlacek <rs@474.at>};
all_from        q{lib/MooseX/Types.pm};

build_requires  q{Test::More},                  0.80;
build_requires  q{FindBin},                     0;

requires        q{Moose},                       0.61;
requires        q{Sub::Install},                0.924;
requires        q{namespace::clean},            0.08;
requires        q{Carp},                        0;
requires        q{Carp::Clan},                  6.00;
requires        q{Scalar::Util},                1.19;

system 'pod2text lib/MooseX/Types.pm > README'
    if -e 'MANIFEST.SKIP';

auto_provides;
auto_install;
WriteAll;
