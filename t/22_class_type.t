use strict;
use warnings;
use Test::More;

BEGIN {
  package MyTypes;

  use MooseX::Types -declare => [ 'ClassyType' ];

  class_type 'ClassyClass';

  subtype ClassyType, as 'ClassyClass';

  #class_type ClassyType, { class => 'ClassyClass' };
}

BEGIN {

  package ClassyClass;

  use Moose;

  sub check { die "FAIL" }

  package ClassyClassConsumer;

  BEGIN { MyTypes->import('ClassyType') }
  use Moose;

  has om_nom => (
    is => 'ro', isa => ClassyType, default => sub { ClassyType->new }
  );

}

ok(my $o = ClassyClassConsumer->new, "Constructor happy");

is(ref($o->om_nom), 'ClassyClass', 'Attribute happy');

ok(ClassyClassConsumer->new(om_nom => ClassyClass->new), 'Constructor happy');

ok(!eval { ClassyClassConsumer->new(om_nom => 3) }, 'Type checked');

done_testing;
