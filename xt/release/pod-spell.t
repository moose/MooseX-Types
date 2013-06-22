use strict;
use warnings;

use Test::Spelling;

my @stopwords;
for (<DATA>) {
    chomp;
    push @stopwords, $_
        unless /\A (?: \# | \s* \z)/msx;
}

add_stopwords(@stopwords);
set_spell_cmd('aspell list -l en');

# This prevents a weird segfault from the aspell command - see
# https://bugs.launchpad.net/ubuntu/+source/aspell/+bug/71322
local $ENV{LC_ALL} = 'C';
all_pod_files_spelling_ok;

__DATA__
API
Florian
Kitover
MyStr
Napiorkowski
Pearcey
Perlop
PositiveInt
Ragwitz
Rolsky
Sedlacek
StrOrArrayRef
TODO
TypeAndSubExporter
autarch
caelum
coercions
documention
gotchas
hdp
inline
instantiation
isa
jnapiorkowski
libs
namespaces
organise
parameterize
parameterized
phaylon
rafl
subclasses
subtype
subtypes
subtyping
typeconstraint
