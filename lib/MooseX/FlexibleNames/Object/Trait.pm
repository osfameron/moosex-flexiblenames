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

package MooseX::FlexibleNames::Object::Trait;
use 5.010; # for smart matching
use Moose::Role;

has fallback => (
    is  => 'ro',
    isa => 'HashRef',
    traits => ['Hash'],
    lazy => 1,
    default => sub { {} },
    handles => {
        set_fallback_data => 'set',
        get_fallback_data => 'get',
    },
);

sub set_flexibly {
    my ($self, $name, $value) = @_;

    my $field = $self->meta->first_flexible_field( sub { 
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
