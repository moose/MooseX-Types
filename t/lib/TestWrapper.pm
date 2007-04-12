package TestWrapper;
use strict;
use warnings;

use Class::C3;
use base 'MooseX::TypeLibrary::Wrapper';

sub type_export_generator {
    my $class = shift;
    my ($type, $full) = @_;
    my $code = $class->next::method(@_);
    return sub { $code->(@_) };
}

sub check_export_generator {
    my $class = shift;
    my ($type, $full, $undef_msg) = @_;
    my $code = $class->next::method(@_);
    return sub {
        return $code unless @_;
        return $code->(@_);
    };
}

sub coercion_export_generator {
    my $class = shift;
    my ($type, $full, $undef_msg) = @_;
    my $code = $class->next::method(@_);
    return sub {
        my $val = $code->(@_);
        die "coercion returned undef\n" unless defined $val;
        return $val;
    };
}

1;
