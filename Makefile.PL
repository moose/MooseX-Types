#!/usr/bin/env perl
use warnings;
use strict;

use inc::Module::Install;

name            q{MooseX-TypeLibrary};
license         q{perl};
author          q{Robert 'phaylon' Sedlacek <rs@474.at>};
all_from        q{lib/MooseX/TypeLibrary.pm};

build_requires  q{Test::More},                  '0.62';
build_requires  q{FindBin},                     0;

requires        q{Moose},                       '0.19';
requires        q{Sub::Uplevel},                '0.14';
requires        q{Sub::Install},                '0.922';
requires        q{namespace::clean},            0;
requires        q{Carp},                        0;

WriteAll;
