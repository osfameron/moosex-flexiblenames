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
use 5.010;
use Moose::Role;
use MooseX::FlexibleNames::Attribute::Trait;

has fallback => (
    is  => 'ro',
    isa => 'HashRef',
    traits => ['Hash'],
    default => sub { {} },
    handles => {
        set_fallback_data => 'set',
        get_fallback_data => 'get',
    },
);

has _flexible_fields => (
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
                $a->meta->insertion_order
                    <=>
                $b->meta->insertion_order
            }
            grep {
                $_->has_matcher
            }
            grep { 
                $_->meta->does_role('MooseX::FlexibleNames::Attribute::Trait')
            } 
            $self->meta->get_all_attributes;

        \@attributes;
    },
);

sub set_flexibly {
    my ($self, $name, $value) = @_;

    my $field = $self->first_flexible_field( sub { 
        my $matcher = $_->matcher;
        $name ~~ $matcher;
    } );

    if ($field) {
        $field->set_value($self, $value);
    }
    else {
        $self->set_fallback_data($name, $value);
    }
}

no Moose::Role;

1;
