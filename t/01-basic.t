#!/usr/bin/perl

use strict; use warnings;
use Test::More tests => 2;
use FindBin '$Bin';

use lib "$Bin/lib";

package TestData;
use Moose;
use MooseX::FlexibleNames;
use Moose::Util::TypeConstraints;

coerce 'Bool',
    from 'Str',
        via {
            return unless $_;
            return if /^(?:false|f|no|n)$/i;
            return 1;
        };

has foo => (
    is     => 'rw',
    isa    => 'Bool',
    coerce => 1,
    matcher => qr/foo/i,
);

package main;
use Test::Deep;

my $x = TestData->new;
$x->set_flexibly( 'FOO' => 'true' );

cmp_deeply($x,
    (bless {
        foo => 1, # coerced name and value
    }, 'TestData'),
    'Set coerced flexible value OK' );

$x->set_flexibly( 'BAR' => 'true' );

cmp_deeply($x,
    (bless {
        foo => 1, # coerced name and value
        fallback => {
            BAR => 'true', # no coercion for fallback
        },
    }, 'TestData'),
    'Set fallback value OK' );

