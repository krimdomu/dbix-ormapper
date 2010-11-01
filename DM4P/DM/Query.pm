package DM4P::DM::Query;

use strict;
use warnings;

use Data::Dumper;

use overload
	'+' => sub  { $_[0]->or(@_); },
	'-' => sub  { $_[0]->and(@_, 1); },
	'&' => sub  { $_[0]->and(@_); },
	'|' => sub  { $_[0]->or(@_); },
	'""' => sub { shift->to_s(@_); };

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------

# Function: new
#
#   Creates an new DM4P::DM::Query Object.
#
# Returns:
#
#   DM4P::DM::Query
sub new {
	my $that = shift;
	my $proto = ref($that) || $that;
	my $self = {};

	bless($self, $proto);

	$self->{$_[0]} = $_[1];
	shift; shift;

	@{$self->{'__parts'}} = [ @_ ];
	$self->{'__bind_params'} = [];

	$self->{'__query_done'} = 0;

	return $self;
}

# ------------------------------------------------------------------------------
# Group: Overload
# ------------------------------------------------------------------------------

# Function: or
#
#    Overload + and |
sub or {
	my $self = shift;
	return DM4P::DM::Query->new(model => $self->model, $_[0], 'OR', $_[1]);
}

# Function: and
#
#    Overload - and &
sub and {
	my $self = shift;
	return DM4P::DM::Query->new(model => $self->model, $_[0], 'AND', $_[1]);
}

# Function: to_s
#
#    Convert Object to String
sub to_s {
	my $self = shift;
	return $self->_get_parts_sql_where();
}

# ------------------------------------------------------------------------------
# Group: Public
# ------------------------------------------------------------------------------

# Function: next
#
#    Get the next record.
#
# Returns:
#
#    DM4P::DM::DataSource
sub next {
	my $self = shift;
}

sub model {
	my $self = shift;
	return $self->{'model'};
}

# ------------------------------------------------------------------------------
# Group: Protected
# ------------------------------------------------------------------------------

sub _get_parts_sql_where {
	my $self = shift;
	my @where = ();

	for my $part (@{$self->{'__parts'}}) {
		for my $subpart (@{$part}) {
			if(ref($subpart) eq "DM4P::DM::Query") {
				push(@where, "(".$subpart->_get_parts_sql_where()." )");
				push(@{$self->{'__bind_params'}}, @{$subpart->{'__bind_params'}});
			} elsif(ref($subpart) eq "DM4P::DM::Query::Part") {
				push(@where, "".$subpart);
				push(@{$self->{'__bind_params'}}, $subpart->val);
			} else {
				push(@where, $subpart);
			}
		}
	}

	return join(" ", @where);
}

1;
