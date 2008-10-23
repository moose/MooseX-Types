package DecoratorLibrary;

use MooseX::Types::Moose qw( Str ArrayRef HashRef Int );
use MooseX::Types
    -declare => [qw(
        MyArrayRefBase
        MyArrayRefInt01
        MyArrayRefInt02
        MyHashRefOfInts
        MyHashRefOfStr
        StrOrArrayRef
        AtLeastOneInt
        Jobs
    )];

## Some questionable messing around
    sub my_subtype {
        my ($subtype, $basetype, @rest) = @_;
        return subtype($subtype, $basetype, shift @rest, shift @rest);
    }
    
    sub my_from {
        return @_;
        
    }
    sub my_as {
        return @_;
    }
## End

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
    from HashRef[ArrayRef],
    via {[ sort map { @$_ } values(%$_) ]};

subtype StrOrArrayRef,
    as Str|ArrayRef;

subtype AtLeastOneInt,
    as ArrayRef[Int],
    where { @$_ > 0 };
    
enum Jobs,
    (qw/Programming Teaching Banking/);
    
1;
