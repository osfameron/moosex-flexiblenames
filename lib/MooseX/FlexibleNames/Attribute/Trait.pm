package MooseX::FlexibleNames::Attribute::Trait;
use Moose::Role;

has matcher => (
    is  => 'ro',
    isa => 'Any', # or any smart-matchable
    predicate => 'has_matcher',
);

no Moose::Role;

# register this as a metaclass alias

package # stop confusing PAUSE
    Moose::Meta::Attribute::Custom::Trait::FlexibleNames;

sub register_implementation { 'MooseX::FlexibleNames::Attribute::Trait' }

1;
