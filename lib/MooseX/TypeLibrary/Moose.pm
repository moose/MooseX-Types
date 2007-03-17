package MooseX::TypeLibrary::Moose;
use warnings;
use strict;

use MooseX::TypeLibrary;
use Moose::Util::TypeConstraints ();
use namespace::clean;

# all available builtin types as short and long name
my %BuiltIn_Storage 
  = map { ($_) x 2 } 
    Moose::Util::TypeConstraints->list_all_type_constraints;

# use prepopulated builtin hash as type storage
sub type_storage { \%BuiltIn_Storage }

1;
