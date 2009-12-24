#!/usr/bin/env perl
use warnings;
use strict;

use inc::Module::Install 0.91;

name            q{MooseX-Types};
license         q{perl};
author          q{Robert "phaylon" Sedlacek <rs@474.at>};
all_from        q{lib/MooseX/Types.pm};

build_requires  q{Test::More},                  '0.80';
build_requires  q{FindBin},                     0;
build_requires  q{Test::Moose},                 0;
build_requires  q{Test::Exception},             0;

requires        q{Moose},                       '0.93';
requires        q{Sub::Install},                '0.924';
requires        q{namespace::clean},            '0.08';
requires        q{Carp},                        0;
requires        q{Carp::Clan},                  '6.00';
requires        q{Scalar::Util},                '1.19';
requires        q{Sub::Name},                   0;

if (can_use('MooseX::Types::IO') && !can_use('MooseX::Types::IO', '0.03')) {
    requires q{MooseX::Types::IO}, '0.03';
}

system 'pod2text lib/MooseX/Types.pm > README'
    if -e 'MANIFEST.SKIP';

auto_provides;
auto_install;
WriteAll;

if ($Module::Install::AUTHOR) {
    Meta->{values}{requires} = [ grep {
        $_->[0] ne 'MooseX::Types::IO'
    } @{ Meta->{values}{requires} } ];

    Meta->write;
}
