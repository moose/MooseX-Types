use strict;
use warnings;

use Test::More tests=>5;
use MooseX::Types;
use MooseX::Types::Moose qw(Any Item );


my $item = subtype as 'Item';

ok Item->equals('Item');
ok Item->equals(Item);

ok ( $item->is_subtype_of('Any'),
  q[$item is subtype of 'Any']);

ok ( Item->is_subtype_of('Any'),
  q[Item is subtype of 'Any']);

ok ( Item->is_subtype_of(Any),
  q[Item is subtype of Any]);


__END__


my $any = subtype as 'Any';

ok ( $item->is_subtype_of(Any),
  q[Item is subtype of Any]);

ok ( $item->is_subtype_of($any),
  q[$item is subtype of $any]);

ok ( Item->is_subtype_of($any),
  q[Item is subtype of $any]);


