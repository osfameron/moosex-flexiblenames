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

package MooseX::FlexibleNames::Metaclass::Trait;
use Moose::Role;

has flexible_fields => (
    is  => 'ro',
    isa => 'ArrayRef', # of attributes?
    traits => ['Array'],
    handles => {
        first_flexible_field => 'first',
    },
    lazy => 1,
    default => sub {
        my $self = shift;
        my @attributes = 
            sort {
                $a->insertion_order
                    <=>
                $b->insertion_order
            }
            grep {
                $_->has_matcher
            }
            grep { 
                $_->meta->does_role('MooseX::FlexibleNames::Attribute::Trait')
            } 
            $self->get_all_attributes;

        \@attributes;
    },
);

no Moose::Role;

1;
