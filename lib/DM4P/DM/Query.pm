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

	for my $d (0..1) {
		$self->{$_[0]} = $_[1];
		shift; shift;
	}

	@{$self->{"__parts"}} = [ @_ ];
	$self->{"__bind_params"} = [];

	$self->{"__query_done"} = 0;
   $self->{"__query_options"} = {};

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
	return DM4P::DM::Query->new(ds => $self->ds, model => $self->model, $_[0], 'OR', $_[1]);
}

# Function: and
#
#    Overload - and &
sub and {
	my $self = shift;
	return DM4P::DM::Query->new(ds => $self->ds, model => $self->model, $_[0], 'AND', $_[1]);
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

	if($self->{'__query_done'} == 0) {
		my $select = $self->ds->get_select($self->to_s, %{ $self->{"__query_options"} });
		$select->fields($self->ds->get_fields());
		$self->{'__stm'} = $self->db->get_statement($select);

		my $i=0;
		for my $bp (@{$self->{'__bind_params'}}) {
			$i++;
			$self->{'__stm'}->bind($i, $bp);
		}

		$self->{'__stm'}->execute();

		$self->{'__query_done'} = 1;
	}

	if(my $row = $self->{'__stm'}->fetchrow_hashref()) {
		return $self->ds->new(%{$row});
	}

	return undef;
}

sub model {
	my $self = shift;
	return $self->{'model'};
}

sub ds {
	my $self = shift;
	return $self->{'ds'};
}

sub db {
	my $self = shift;
	#return DM4P::get_connection();
	return $self->ds->get_data_source;
}

# ------------------------------------------------------------------------------
# Group: Query Modification
# ------------------------------------------------------------------------------

# 
# Function: order
#
#    Set the order of the query.
#
# Returns:
#
#    DM4P::DM::Query
sub order {
   my ($self, $order_by) = @_;
   $self->{"__query_options"}->{"order_by"} = $order_by;

   return $self;
}

# 
# Function: desc
#
#    Set the order of the query descending.
#
# Returns:
#
#    DM4P::DM::Query
sub desc {
   my ($self) = @_;
   $self->{"__query_options"}->{"order_direction"} = "desc";

   return $self;
}

# 
# Function: asc
#
#    Set the order of the query ascending.
#
# Returns:
#
#    DM4P::DM::Query
sub asc {
   my ($self) = @_;
   $self->{"order_direction"} = "asc";

   return $self;
}


# ------------------------------------------------------------------------------
# Group: Protected
# ------------------------------------------------------------------------------

sub _get_parts_sql_where {
	my $self = shift;
	my @where = ();

	@{$self->{'__bind_params'}} = ();

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
