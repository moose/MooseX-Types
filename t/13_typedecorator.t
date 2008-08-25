#!/usr/bin/env perl
use warnings;
use strict;

use Test::More tests => 29;
use Test::Exception;
use FindBin;
use lib "$FindBin::Bin/lib";

{
    package Test::MooseX::TypeLibrary::TypeDecorator;
    
    use Moose;
    use MooseX::Types::Moose qw(
        Int
    );
    use DecoratorLibrary qw(
        MyArrayRefBase MyArrayRefInt01 MyArrayRefInt02 StrOrArrayRef
    );
    
    has 'arrayrefbase' => (is=>'rw', isa=>MyArrayRefBase, coerce=>1);
    has 'arrayrefint01' => (is=>'rw', isa=>MyArrayRefInt01, coerce=>1);
    has 'arrayrefint02' => (is=>'rw', isa=>MyArrayRefInt02, coerce=>1);
    has 'arrayrefint03' => (is=>'rw', isa=>MyArrayRefBase[Int]);
    has 'StrOrArrayRef' => (is=>'rw', isa=>StrOrArrayRef);
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
 => 'Assignment is correct';

ok $type->arrayrefbase('d,e,f')
 => 'Assignment arrayrefbase d,e,f to test coercion';
 
is_deeply $type->arrayrefbase, [qw(d e f)],
 => 'Assignment and coercion is correct';

## test arrayrefint01 normal and coercion

ok $type->arrayrefint01([qw(1 2 3)])
 => 'Assignment arrayrefint01 qw(1 2 3)';
 
is_deeply $type->arrayrefint01, [qw(1 2 3)],
 => 'Assignment is correct';

ok $type->arrayrefint01('4.5.6')
 => 'Assigned arrayrefint01 4.5.6 to test coercion from Str';
 
is_deeply $type->arrayrefint01, [qw(4 5 6)],
 => 'Assignment and coercion is correct';

ok $type->arrayrefint01({a=>7,b=>8})
 => 'Assigned arrayrefint01 {a=>7,b=>8} to test coercion from HashRef';
 
is_deeply $type->arrayrefint01, [qw(7 8)],
 => 'Assignment and coercion is correct';
 
throws_ok sub {
    $type->arrayrefint01([qw(a b c)])
}, qr/Attribute \(arrayrefint01\) does not pass the type constraint/ => 'Dies when values are strings';

## test arrayrefint02 normal and coercion

ok $type->arrayrefint02([qw(1 2 3)])
 => 'Assigned arrayrefint02 qw(1 2 3)';
 
is_deeply $type->arrayrefint02, [qw(1 2 3)],
 => 'Assignment is correct';

ok $type->arrayrefint02('4:5:6')
 => 'Assigned arrayrefint02 4:5:6 to test coercion from Str';
 
is_deeply $type->arrayrefint02, [qw(4 5 6)],
 => 'Assignment and coercion is correct';

ok $type->arrayrefint02({a=>7,b=>8})
 => 'Assigned arrayrefint02 {a=>7,b=>8} to test coercion from HashRef';
 
is_deeply $type->arrayrefint02, [qw(7 8)],
 => 'Assignment and coercion is correct';
 
ok $type->arrayrefint02({a=>'AA',b=>'BBB', c=>'CCCCCCC'})
 => "Assigned arrayrefint02 {a=>'AA',b=>'BBB', c=>'CCCCCCC'} to test coercion from HashRef";
 
is_deeply $type->arrayrefint02, [qw(2 3 7)],
 => 'Assignment and coercion is correct';

ok $type->arrayrefint02({a=>[1,2],b=>[3,4]})
 => "Assigned arrayrefint02 {a=>[1,2],b=>[3,4]} to test coercion from HashRef";
 
is_deeply $type->arrayrefint02, [qw(1 2 3 4)],
 => 'Assignment and coercion is correct';
 
# test arrayrefint03 

ok $type->arrayrefint03([qw(11 12 13)])
 => 'Assigned arrayrefint01 qw(11 12 13)';
 
is_deeply $type->arrayrefint03, [qw(11 12 13)],
 => 'Assignment is correct';
 
throws_ok sub {
    $type->arrayrefint03([qw(a b c)])
}, qr/Attribute \(arrayrefint03\) does not pass the type constraint/ => 'Dies when values are strings';

# TEST StrOrArrayRef

ok $type->StrOrArrayRef('string')
 => 'String part of union is good';

ok $type->StrOrArrayRef([1,2,3])
 => 'arrayref part of union is good';
 
throws_ok sub {
    $type->StrOrArrayRef({a=>111});
}, qr/Attribute \(StrOrArrayRef\) does not pass the type constraint/ => 'Correctly failed to use a hashref';