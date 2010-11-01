package DM4P::DM::Comparable;

use strict;
use warnings;

use Data::Dumper;

use overload 
	'>'  => sub  { $_[0]->overload_compare(@_, '>'); },
	'<'  => sub  { $_[0]->overload_compare(@_, '<'); },
	'==' => sub  { $_[0]->overload_compare(@_, '='); },
	'eq' => sub  { $_[0]->overload_compare(@_, '='); };

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------

# Function: new
#
#   Creates an new DM4P::DM::Comparable Object.
#
# Returns:
#
#   DM4P::DM::Comparable
sub new {
	my $that = shift;
	my $proto = ref($that) || $that;
	my $self = { @_ };

	bless($self, $proto);

	return $self;
}


# ------------------------------------------------------------------------------
# Group: Overload
# ------------------------------------------------------------------------------
sub overload_compare {
	my $self = shift;
	my ($l, $r, $dummy, $op) = @_;

	my ($key, $val);

	if(ref($l) eq "DM4P::DM::Comparable") {
		$key = $l->key;
	} else {
		$key = $l;
	}

	if(ref($r) eq "DM4P::DM::Comparable") {
		$val = $l->key;
	} else {
		$val = $r;
	}

	return DM4P::DM::Query::Part->new(model => $self->model, key => $key, val => $val, type => '', operator => $op);
}

# ------------------------------------------------------------------------------
# Group: Public
# ------------------------------------------------------------------------------

sub key {
	my $self = shift;
	return $self->{'key'};
}

sub model {
	my $self = shift;
	return $self->{'model'};
}

1;
