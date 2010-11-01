package DM4P::DM::DataSource::Table;

use strict;
use warnings;

use base qw(DM4P::DM::DataSource);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------

# Function: new
#
#   Creates an new DM4P::DM::DataSource::Table Object.
#
# Returns:
#
#   DM4P::DM::DataSource::Table
sub new {
	my $that = shift;
	my $proto = ref($that) || $that;
   	my $self = $proto->SUPER::new(@_);

	bless($self, $proto);

	return $self;
}

sub get_select {
	my $self = shift;
	my $qry = shift;

	return DM4P::SQL::Query::SELECT->new()
		->from($self->table)
		->where($qry);
}

sub table {
	my ($class, $name) = @_;
	no strict 'refs';

	if($name) {
		my $var = $class."::db_table";
		$$var = $name;
	} else {
		my $var = $class."::db_table";
		return $$var;
	}
}

1;
