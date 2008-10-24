<<<<<<< .working
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
        SubOfMyArrayRefInt01
        BiggerInt
    )];

subtype MyArrayRefBase,
    as ArrayRef;
    
coerce MyArrayRefBase,
    from Str,
    via {[split(',', $_)]};
    
subtype MyArrayRefInt01,
    as ArrayRef[Int];

subtype BiggerInt,
    as Int,
    where {$_>10};

## We can change this when the .61 Moose comes out.  When that happens we will
## have the correct patch to Moose::Meta::TypeConstraint::Parameterized to let
## us support parameterizing parameterized subtypes.  When we get this we can
## then replace the where clause with:

    ##as MyArrayRefInt01[BiggerInt];

subtype SubOfMyArrayRefInt01,
    as MyArrayRefInt01,
    where {
        my $ok_or_not = 1;
        foreach my $int (@$_) {
            $ok_or_not = $int>10 ? 1:0
             if $ok_or_not;
        } $ok_or_not;
    };

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
=======
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
        SubOfMyArrayRefInt01
        BiggerInt
    )];

subtype MyArrayRefBase,
    as ArrayRef;
    
coerce MyArrayRefBase,
    from Str,
    via {[split(',', $_)]};
    
subtype MyArrayRefInt01,
    as ArrayRef[Int];

subtype BiggerInt,
    as Int,
    where {$_>10};
    
subtype SubOfMyArrayRefInt01,
    as MyArrayRefInt01[BiggerInt];

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
>>>>>>> .merge-right.r6407
