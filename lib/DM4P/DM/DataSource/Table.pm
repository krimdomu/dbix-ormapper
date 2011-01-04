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
		my $var = (ref($class) || $class ) ."::db_table";
		$$var = $name;
	} else {
		my $var = (ref($class) || $class) ."::db_table";
		return $$var;
	}
}

# ------------------------------------------------------------------------------
# Group: Relations
# ------------------------------------------------------------------------------

sub has_n {
   my ($class, $name, $join_pkg, $opts) = @_;
}

sub has {
   my ($class, $name, $join_pkg, $opts) = @_;
}

sub belongs_to {
   my ($class, $name, $join_pkg, $opts) = @_;
}

# ------------------------------------------------------------------------------
# Group: Datamanipulation
# ------------------------------------------------------------------------------

sub save {
   my ($self) = @_;

   my $insert = DM4P::SQL::Query::INSERT->new()
                                       ->table($self->table);
   for my $key (keys %{$self->{'__data'}}) {
      $insert->$key($self->{'__data'}->{$key});
   }

   my $db = DM4P::get_connection();
   my $stm = $db->get_statement($insert);

   $stm->execute;
}

1;
