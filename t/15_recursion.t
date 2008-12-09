## Test case inspired by Stevan Little

BEGIN {
    package MooseX::Types::Test::Recursion;
    
    use Moose;

    use Moose::Util::TypeConstraints;
    use MooseX::Types::Moose qw(Str HashRef);
    use MooseX::Types -declare => [qw(
        RecursiveHashRef
    )];

    ## Define a recursive subtype and Cthulhu save us.
    subtype RecursiveHashRef()
     => as HashRef[Str() | RecursiveHashRef()];
}

{
    package MooseX::Types::Test::Recursion::TestRunner;
    
    BEGIN {
        use Test::More 'no_plan';
        use Data::Dump qw/dump/;
        
        MooseX::Types::Test::Recursion->import(':all');
    };

    
    ok RecursiveHashRef->check({key=>"value"})
     => 'properly validated {key=>"value"}';
     
    ok RecursiveHashRef->check({key=>{subkey=>"value"}})
     => 'properly validated {key=>{subkey=>"value"}}';
     
     
    warn dump RecursiveHashRef();
}






