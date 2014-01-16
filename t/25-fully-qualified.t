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

    ::ok(is_NonEmptyStr('a string'), 'is_NonEmptyStr');
    ::ok(NonEmptyStr->isa('Moose::Meta::TypeConstraint'), 'type is available as an import');

    ::ok(MyApp->can('NonEmptyStr'), 'type is still available as a method on the importing class');

    for my $phase ('before', 'after')
    {
        ::note "$phase calling namespace::autoclean";

        SKIP: {
            ::skip('Moose before 2.1005 could not install blessed subs as methods', 1) if Moose->VERSION < 2.1005;
            ::ok(MyTypeLibrary->can('NonEmptyStr'),
                "$phase calling namespace::autoclean: type is available as a method on the declaring class");
        }

        ::ok(eval '\&MyTypeLibrary::NonEmptyStr',
            "$phase calling namespace::autoclean: type is available as a fully-qualified name on the declaring class");

        SKIP: {
            ::skip('Moose before 2.1005 could not install blessed subs as methods', 1) if Moose->VERSION < 2.1005;
            ::ok(MyTypeLibrary::NonEmptyStr->isa('Moose::Meta::TypeConstraint'),
                "$phase calling namespace::autoclean: type is the right type")
                or ::diag('MyTypeLibrary is type: ' .join(', ', @MyTypeLibrary::ISA));
        }

        last if $phase eq 'after';
    }
    continue
    {
        ::note 'calling namespace::autoclean';
        eval q{use namespace::autoclean};
    }

    ::ok(!MyApp->can('NonEmptyStr'), 'type is no longer available as a method on the importing class');
}

done_testing;
