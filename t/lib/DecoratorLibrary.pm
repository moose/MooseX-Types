package DecoratorLibrary;

use warnings;
use strict;

use MooseX::Types::Moose qw( Str ArrayRef HashRef Int );
use MooseX::Types
    -declare => [qw(
        MyArrayRefBase
        MyArrayRefInt01
        MyArrayRefInt02
        MyHashRefOfInts
        MyHashRefOfStr
    )];

subtype MyArrayRefBase,
    as ArrayRef;
    
coerce MyArrayRefBase,
    from Str,
    via {[split(',', $_)]};
    
subtype MyArrayRefInt01,
    as ArrayRef[Int];

coerce MyArrayRefInt01,
    from Str,
    via {[split('\.',$_)]},
    from HashRef,
    via {[sort values(%$_)]};
    
subtype MyArrayRefInt02,
    as MyArrayRefBase[Int];
    
subtype MyHashRefOfInts,
    as HashRef[Int];
    
subtype MyHashRefOfStr,
    as HashRef[Str];

coerce MyArrayRefInt02,
    from Str,
    via {[split(':',$_)]},
    from MyHashRefOfInts,
    via {[sort values(%$_)]},
    from MyHashRefOfStr,
    via {[ sort map { length $_ } values(%$_) ]},
    ### Can't do HashRef[ArrayRef] here, need to force precidence I guess???
    from HashRef([ArrayRef]),
    via {[ sort map { @$_ } values(%$_)] };
    
1;
