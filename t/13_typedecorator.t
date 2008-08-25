#!/usr/bin/env perl
use warnings;
use strict;

use Test::More tests => 10;
use FindBin;
use lib "$FindBin::Bin/lib";

{
    package Test::MooseX::TypeLibrary::TypeDecorator;
    
    use Moose;
    use DecoratorLibrary qw(
        MyArrayRefBase
        MyArrayRefInt01
        MyArrayRefInt02
    );
    
    has 'arrayrefbase' => (is=>'rw', isa=>MyArrayRefBase, coerce=>1);
    has 'arrayrefint01' => (is=>'rw', isa=>MyArrayRefInt01, coerce=>1);
}

## Make sure we have a 'create object sanity check'

ok my $type = Test::MooseX::TypeLibrary::TypeDecorator->new(),
 => 'Created some sort of object';
 
isa_ok $type, 'Test::MooseX::TypeLibrary::TypeDecorator'
 => "Yes, it's the correct kind of object";

## test arrayrefbase normal and coercion

ok $type->arrayrefbase([qw(a b c)])
 => 'Assigned arrayrefbase qw(a b c)';
 
is_deeply $type->arrayrefbase, [qw(a b c)],
 => 'Assigment is correct';

ok $type->arrayrefbase('d,e,f')
 => 'Assigned arrayrefbase d,e,f to test coercion';
 
is_deeply $type->arrayrefbase, [qw(d e f)],
 => 'Assigment and coercion is correct';

## test arrayrefint01 normal and coercion

ok $type->arrayrefint01([qw(1 2 3)])
 => 'Assigned arrayrefbase qw(1 2 3)';
 
is_deeply $type->arrayrefint01, [qw(1 2 3)],
 => 'Assigment is correct';

ok $type->arrayrefint01('4.5.6')
 => 'Assigned arrayrefbase 4.5.6 to test coercion from Str';
 
is_deeply $type->arrayrefint01, [qw(4 5 6)],
 => 'Assigment and coercion is correct';

ok $type->arrayrefint01({a=>7,b=>8})
 => 'Assigned arrayrefbase {a=>7,b=>8} to test coercion from HashRef';
 
is_deeply $type->arrayrefint01, [qw(7 8)],
 => 'Assigment and coercion is correct';
 
#use Data::Dump qw/dump/;
#warn dump  MyArrayRefInt01;
#warn dump MyArrayRefBase->validate('aaa,bbb,ccc');
