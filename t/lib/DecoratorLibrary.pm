package DecoratorLibrary;

use warnings;
use strict;

use MooseX::Types::Moose qw( Str ArrayRef HashRef Int );
use MooseX::Types
    -declare => [qw(
        MyArrayRefBase
        MyArrayRefInt01
        MyArrayRefInt02
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
    via {[values(%$_)]};
    
subtype MyArrayRefInt02,
    as MyArrayRefBase[Int];

coerce MyArrayRefInt02,
    from Str,
    via {[split(':',$_)]};
    from HashRef[Int],
    via {[values(%$_)]},
    from HashRef[Str],
    via {[ map { length $_ } values(%_) ]};
1;
