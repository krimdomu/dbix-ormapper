package DM4P::DM::Query::Part;

use strict;
use warnings;

use Data::Dumper;

use attributes;

use overload
	'+'  => sub { $_[0]->or(@_); },
	'|'  => sub { $_[0]->or(@_); },
	'&'  => sub { $_[0]->and(@_); },
	'-'  => sub { $_[0]->and(@_); },
	'""' => sub { $_[0]->to_s(@_); };

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------

# Function: new
#
#   Creates an new DM4P::DM::Query::Part Object.
#
# Returns:
#
#   DM4P::DM::Query::Part
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
sub to_s {
	my $self = shift;
	return $self->type . " #" . $self->key . " " . $self->operator . " ?";
}

sub or {
	my $self = shift;
	$_[0]->type = '';
	$_[1]->type = 'OR';
	return DM4P::DM::Query->new(ds => $self->ds, model => $self->model, @_);
}

sub and {
	my $self = shift;
	$_[0]->type = '';
	$_[1]->type = 'AND';
	return DM4P::DM::Query->new(ds => $self->ds, model => $self->model, @_);
}

# ------------------------------------------------------------------------------
# Group: Public
# ------------------------------------------------------------------------------
sub key : lvalue {
	my $self = shift;
	$self->{'key'};
}

sub val : lvalue {
	my $self = shift;
	$self->{'val'};
}

sub operator : lvalue {
	my $self = shift;
	$self->{'operator'};
}

sub type : lvalue {
	my $self = shift;
	$self->{'type'};
}

sub model {
	my $self = shift;
	return $self->{'model'};
}

sub ds {
	my $self = shift;
	return $self->{'ds'};
}


1;
