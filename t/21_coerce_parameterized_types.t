#!/usr/bin/env perl
use strict;
use warnings;
use Test::Exception;

use Test::More tests => 2;

BEGIN {
    package TypeLib;
    use MooseX::Types -declare => [qw/MyType ArrayRefOfMyType/];
    use MooseX::Types::Moose qw/ArrayRef Str/;

    subtype MyType, as Str, where {
	length == 1
    };

    coerce ArrayRef[MyType], from Str, via {
	[split //]
    };

# same thing with an explicit subtype
    subtype ArrayRefOfMyType, as ArrayRef[MyType];

    coerce ArrayRefOfMyType, from Str, via {
	[split //]
    };
}
{
    package AClass;
    use Moose;
    BEGIN { TypeLib->import(qw/MyType ArrayRefOfMyType/) };
    use MooseX::Types::Moose 'ArrayRef';

    has parameterized => (is => 'rw', isa => ArrayRef[MyType], coerce => 1);
    has subtype => (is => 'rw', isa => ArrayRefOfMyType, coerce => 1);
}

my $instance = AClass->new;

lives_ok { $instance->parameterized('foo') }
    'coercion applied to parameterized type';

lives_ok { $instance->subtype('foo') } 'coercion applied to subtype';
