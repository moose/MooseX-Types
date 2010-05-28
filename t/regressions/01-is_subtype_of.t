use strict;
use warnings;

use Test::More tests=>6;
use MooseX::Types;
use MooseX::Types::Moose qw(Any Item );


my $item = subtype as 'Item';

ok ( $item->is_subtype_of('Any'),
  q[$item is subtype of 'Any']);

ok ( Item->is_subtype_of('Any'),
  q[Item is subtype of 'Any']);

ok ( $item->is_subtype_of(Any),
  q[Item is subtype of Any]);

ok ( Item->is_subtype_of(Any),
  q[Item is subtype of Any]);

my $any = subtype as 'Any';

ok ( $item->is_subtype_of($any),
  q[$item is subtype of $any]);

ok ( Item->is_subtype_of($any),
  q[Item is subtype of $any]);


