#!/usr/bin/perl

use strict; use warnings;
use Test::More tests => 1;
use FindBin '$Bin';

use lib "$Bin/lib";

package TestData;
use Moose;
use MooseX::FlexibleNames;

has foo_specific => (
    is     => 'rw',
    matcher => 'foo',
);
has f_generic => (
    is     => 'rw',
    matcher => qr/^f\w+/,
);
has qux_or_quux => (
    is => 'rw',
    matcher => [ 'qux', 'quux' ],
);
has six_letters => (
    is => 'rw',
    matcher => sub { length $_[0] == 6 },
);

has oops_qux => (
    is => 'rw',
    matcher => 'qux',
);
has oops_quux => (
    is => 'rw',
    matcher => 'quux',
);

package main;
use Test::Deep;

my $x = TestData->new;
$x->set_flexibly( foo  => 'foo' );
$x->set_flexibly( fum  => 'fum' );
$x->set_flexibly( qux  => 'qux' );
$x->set_flexibly( quux => 'quux' );
$x->set_flexibly( abcdef => 'abcdef' );
$x->set_flexibly( bar  => 'bar' );

cmp_deeply($x,
    (bless {
        foo_specific => 'foo', 
        f_generic    => 'fum', 
        qux_or_quux  => 'quux',
        six_letters  => 'abcdef',
        fallback     => {
            bar => 'bar',
        }
    }, 'TestData'),
    'Set coerced flexible value OK' );

