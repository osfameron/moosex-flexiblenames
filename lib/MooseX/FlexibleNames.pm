=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION

=cut


=head1 AUTHOR and LICENSE

   (C)  osfameron 2009, <osfameron@cpan.org>

For support, try emailing me, or grabbing me on irc #london.pm or #moose
on irc.perl.org

This module is released under the same terms as Perl itself.

=cut

package MooseX::FlexibleNames;
use 5.010; # for smart matching

use Moose ();
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    install           => [qw( import unimport )],
    metaclass_roles   => ['MooseX::FlexibleNames::Attribute::Trait'],
    base_class_roles  => ['MooseX::FlexibleNames::Object::Trait'],
);

1;
