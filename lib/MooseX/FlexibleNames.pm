=head1 NAME

MooseX::FlexibleNames - set Moose objects from data provided by non-programmers

=head1 SYNOPSIS

    package My::Metadata;
    use Moose;
    use MooseX::FlexibleNames;

    has name => (
        is  => 'rw',
        isa => 'Str',
        matcher => ['Name', 'Title'],
    );

    has display_score => (
        is  => 'rw',
        isa => 'Bool',
        coerce => 1,
        matcher => qr/^display scor(?:e|ing)/i,
    );

    has category => (
        is => 'rw',
        isa => 'My::Category',
        coerce => 1,
        matcher => \&is_valid_category_name,
    );

    ############
    package main;

    my $meta = My::Metadata->new;

    while (my ($k, $v) = get_metadata_from_user_input() ) {
        $meta->set_flexibly($k, $v);
    }

=head1 DESCRIPTION

Some APIs should be utterly rigid, and accept only well defined input, or
fail horribly.  Sometimes though, you will want to follow Postel's law and:

   "Be conservative in what you do, be liberal in what you accept from others."

This may be useful when, for example, you are importing data prepared not by
an analyst programmer, but by a business specialist.  Or when your routine
accepts data from multiple versions of an API, and the names of the keys have
changed.

Moose already coerces values for you: in the case above, for example, you might
want to coerce strings like C<True> and C<Y> and C<Yes> to become C<1>(the true
value in a C<Bool> type).  This extension allows you to coerce the field name
too.

=head2 C<set_flexibly>

    $obj->set_flexibly($key, $val);

All the fields of the object are scanned, in order of definition, and the
first with a valid C<matcher> is selected.  The matcher is chosen if it passes
a Perl 5.10 L<Smart match|perlsyn/Smart matching in detail>.

    $obj->set_flexibly(Title => 'The Thought Gang');

would set the C<name> field above, for example.

=head2 C<fallback>

If there is no field matching, a C<HashRef> field called C<fallback> will
be created.

    $obj->set(foo => 'bar');

would create

    $obj->fallback 
    # {
    #    foo => 'bar',
    # }

You can also call

    $obj->get_fallback_data('foo');
    $obj->set_fallback_data('foo', 'baz');

=head1 AUTHOR and LICENSE

   (C)  osfameron 2010, <osfameron@cpan.org>

For support, try emailing me, or grabbing me on irc #london.pm or #moose
on irc.perl.org

This module is released under the same terms as Perl itself.

=cut

package MooseX::FlexibleNames;
use 5.010; # for smart matching

our $VERSION = 0.01;

use Moose ();
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    metaclass_roles 
        => ['MooseX::FlexibleNames::Metaclass::Trait'],
    attribute_metaclass_roles 
        => ['MooseX::FlexibleNames::Attribute::Trait'],
    base_class_roles  
        => ['MooseX::FlexibleNames::Object::Trait'],
);

1;
