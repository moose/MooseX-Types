package MooseX::Types;

=head1 NAME

MooseX::Types - Organise your Moose types in libraries

=cut

#use warnings;
#use strict;

use Sub::Uplevel;
use Moose::Util::TypeConstraints;
use MooseX::Types::Base             ();
use MooseX::Types::Util             qw( filter_tags );
use MooseX::Types::UndefinedType;
use Sub::Install                    qw( install_sub );
use Carp                            qw( croak );
use Moose;

use namespace::clean -except => [qw( meta )];

our $VERSION = 0.04;

my $UndefMsg = q{Action for type '%s' not yet defined in library '%s'};

=head1 SYNOPSIS

=head2 Library Definition

  package MyLibrary;

  # predeclare our own types
  use MooseX::Types 
      -declare => [qw( PositiveInt NegativeInt )];

  # import builtin types
  use MooseX::Types::Moose 'Int';

  # type definition
  subtype PositiveInt, 
      as Int, 
      where { $_ > 0 },
      message { "Int is not larger than 0" };
  
  subtype NegativeInt,
      as Int,
      where { $_ < 0 },
      message { "Int is not smaller than 0" };

  # type coercion
  coerce PositiveInt,
      from Int,
          via { 1 };

  1;

=head2 Usage

  package Foo;
  use Moose;
  use MyLibrary qw( PositiveInt NegativeInt );

  # use the exported constants as type names
  has 'bar',
      isa    => PositiveInt,
      is     => 'rw';
  has 'baz',
      isa    => NegativeInt,
      is     => 'rw';

  sub quux {
      my ($self, $value);

      # test the value
      print "positive\n" if is_PositiveInt($value);
      print "negative\n" if is_NegativeInt($value);

      # coerce the value, NegativeInt doesn't have a coercion
      # helper, since it didn't define any coercions.
      $value = to_PositiveInt($value) or die "Cannot coerce";
  }

  1;

=head1 DESCRIPTION

The types provided with L<Moose> are by design global. This package helps
you to organise and selectively import your own and the built-in types in
libraries. As a nice side effect, it catches typos at compile-time too.

However, the main reason for this module is to provide an easy way to not
have conflicts with your type names, since the internal fully qualified
names of the types will be prefixed with the library's name.

This module will also provide you with some helper functions to make it 
easier to use Moose types in your code.

=head1 TYPE HANDLER FUNCTIONS

=head2 $type

A constant with the name of your type. It contains the type's fully
qualified name. Takes no value, as all constants.

=head2 is_$type

This handler takes a value and tests if it is a valid value for this
C<$type>. It will return true or false.

=head2 to_$type

A handler that will take a value and coerce it into the C<$type>. It will
return a false value if the type could not be coerced.

B<Important Note>: This handler will only be exported for types that can
do type coercion. This has the advantage that a coercion to a type that
cannot hasn't defined any coercions will lead to a compile-time error.

=head1 LIBRARY DEFINITION

A MooseX::Types is just a normal Perl module. Unlike Moose 
itself, it does not install C<use strict> and C<use warnings> in your
class by default, so this is up to you.

The only thing a library is required to do is

  use MooseX::Types -declare => \@types;

with C<@types> being a list of types you wish to define in this library.
This line will install a proper base class in your package as well as the
full set of L<handlers|/"TYPE HANDLER FUNCTIONS"> for your declared 
types. It will then hand control over to L<Moose::Util::TypeConstraints>'
C<import> method to export the functions you will need to declare your
types.

If you want to use Moose' built-in types (e.g. for subtyping) you will 
want to 

  use MooseX::Types::Moose @types;

to import the helpers from the shipped L<MooseX::Types::Moose>
library which can export all types that come with Moose.

You will have to define coercions for your types or your library won't
export a L</to_$type> coercion helper for it.

Note that you currently cannot define types containing C<::>, since 
exporting would be a problem.

You also don't need to use C<warnings> and C<strict>, since the
definition of a library automatically exports those.

=head1 LIBRARY USAGE

You can import the L<"type helpers"|/"TYPE HANDLER FUNCTIONS"> of a
library by C<use>ing it with a list of types to import as arguments. If
you want all of them, use the C<:all> tag. For example:

  use MyLibrary      ':all';
  use MyOtherLibrary qw( TypeA TypeB );

MooseX::Types comes with a library of Moose' built-in types called
L<MooseX::Types::Moose>.

=head1 WRAPPING A LIBRARY

You can define your own wrapper subclasses to manipulate the behaviour
of a set of library exports. Here is an example:

  package MyWrapper;
  use strict;
  use Class::C3;
  use base 'MooseX::Types::Wrapper';

  sub coercion_export_generator {
      my $class = shift;
      my $code = $class->next::method(@_);
      return sub {
          my $value = $code->(@_);
          warn "Coercion returned undef!"
              unless defined $value;
          return $value;
      };
  }

  1;

This class wraps the coercion generator (e.g., C<to_Int()>) and warns
if a coercion returned an undefined value. You can wrap any library
with this:

  package Foo;
  use strict;
  use MyWrapper MyLibrary => [qw( Foo Bar )],
                Moose     => [qw( Str Int )];

  ...
  1;

The C<Moose> library name is a special shortcut for 
L<MooseX::Types::Moose>.

=head2 Generator methods you can overload

=over 4

=item type_export_generator( $short, $full )

Creates a closure returning the type's L<Moose::Meta::TypeConstraint> 
object. 

=item check_export_generator( $short, $full, $undef_message )

This creates the closure used to test if a value is valid for this type.

=item coercion_export_generator( $short, $full, $undef_message )

This is the closure that's doing coercions.

=back

=head2 Provided Parameters

=over 4

=item $short

The short, exported name of the type.

=item $full

The fully qualified name of this type as L<Moose> knows it.

=item $undef_message

A message that will be thrown when type functionality is used but the
type does not yet exist.

=back

=head1 METHODS

=head2 import

Installs the L<MooseX::Types::Base> class into the caller and 
exports types according to the specification described in 
L</"LIBRARY DEFINITION">. This will continue to 
L<Moose::Util::TypeConstraints>' C<import> method to export helper
functions you will need to declare your types.

=cut

sub import {
    my ($class, %args) = @_;
    my  $callee = caller;

    # everyone should want this
    strict->import;
    warnings->import;

    # inject base class into new library
    {   no strict 'refs';
        unshift @{ $callee . '::ISA' }, 'MooseX::Types::Base';
    }

    # generate predeclared type helpers
    if (my @orig_declare = @{ $args{ -declare } || [] }) {
        my ($tags, $declare) = filter_tags @orig_declare;

        for my $type (@$declare) {

            croak "Cannot create a type containing '::' ($type) at the moment"
                if $type =~ /::/;

            $callee->add_type($type);
            $callee->export_type_into(
                $callee, $type, 
                sprintf($UndefMsg, $type, $callee), 
                -full => 1,
            );
        }
    }

    # run type constraints import
    return Moose::Util::TypeConstraints->import({ into => $callee });
}

=head2 type_export_generator

Generate a type export, e.g. C<Int()>. This will return either a
L<Moose::Meta::TypeConstraint> object, or alternatively a
L<MooseX::Types::UndefinedType> object if the type was not
yet defined.

=cut

sub type_export_generator {
    my ($class, $type, $full) = @_;
    return sub { 
        return find_type_constraint($full)
            || MooseX::Types::UndefinedType->new($full);
    };
}

=head2 coercion_export_generator

This generates a coercion handler function, e.g. C<to_Int($value)>. 

=cut

sub coercion_export_generator {
    my ($class, $type, $full, $undef_msg) = @_;
    return sub {
        my ($value) = @_;

        # we need a type object
        my $tobj = find_type_constraint($full) or croak $undef_msg;
        my $return = $tobj->coerce($value);

        # non-successful coercion returns false
        return unless $tobj->check($return);

        return $return;
    }
}

=head2 check_export_generator

Generates a constraint check closure, e.g. C<is_Int($value)>.

=cut

sub check_export_generator {
    my ($class, $type, $full, $undef_msg) = @_;
    return sub {
        my ($value) = @_;

        # we need a type object
        my $tobj = find_type_constraint($full) or croak $undef_msg;

        return $tobj->check($value);
    }
}

=head1 CAVEATS

A library makes the types quasi-unique by prefixing their names with (by
default) the library package name. If you're only using the type handler
functions provided by MooseX::Types, you shouldn't ever have to use
a type's actual full name.

=head1 SEE ALSO

L<Moose>, L<Moose::Util::TypeConstraints>, L<MooseX::Types::Moose>

=head1 AUTHOR AND COPYRIGHT

Robert 'phaylon' Sedlacek C<E<lt>rs@474.atE<gt>>, with many thanks to
the C<#moose> cabal on C<irc.perl.org>.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;
