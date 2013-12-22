use strict;
use warnings FATAL => 'all';

use Test::More;
use if $ENV{AUTHOR_TESTING}, 'Test::Warnings';

{
    package MyTypeLibrary;
    use MooseX::Types::Moose 'Str';
    use MooseX::Types -declare => [ 'NonEmptyStr' ];
    use namespace::autoclean;
    subtype NonEmptyStr,
        as Str,
        where { length $_ },
        message { 'Str must not be empty' };
}

{
    package MyApp;
    BEGIN { MyTypeLibrary->import('NonEmptyStr') }

    my @isa = eval '@' . Scalar::Util::blessed(NonEmptyStr) . '::ISA';
print "### " . NonEmptyStr . " ISA @isa\n";
#print "### type: ", Dumper(NonEmptyStr);
use Data::Dumper;

local $Data::Dumper::Deparse = 1;
print "### type declarator import sub: ", Dumper(\&MyTypeLibrary::import);

print "### MyTypeLibrary ISA: @MyTypeLibrary::ISA\n";

    ::ok(is_NonEmptyStr('a string'), 'is_NonEmptyStr');
    ::ok(NonEmptyStr->isa('Moose::Meta::TypeConstraint'), 'type is available as an import');

    for my $phase ('before', 'after')
    {
        ::note "$phase calling namespace::autoclean";

        ::ok(MyTypeLibrary->can('NonEmptyStr'), 'type is available as a fully-qualified name on the declaring class');
        ::ok(eval '\&MyTypeLibrary::NonEmptyStr', 'ditto');

        ::ok(MyTypeLibrary::NonEmptyStr->isa('Moose::Meta::TypeConstraint'), 'type is the right type');

        last if $phase eq 'after';
    }
    continue
    {
        ::note 'calling namespace::autoclean';
        eval q{namespace::autoclean->import};
    }

# XXX given the code in place right now, this *should* be passing. see that we
# don't pass an installer arg when exporting to MyApp!
    ::ok(!MyApp->can('NonEmptyStr'), 'type is not available as a method on the importing class');
}

done_testing;
