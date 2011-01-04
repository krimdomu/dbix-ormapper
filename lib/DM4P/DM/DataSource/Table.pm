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

sub primary_key {
   my ($class, $name) = @_;
	no strict 'refs';

	if($name) {
		my $var = (ref($class) || $class ) ."::primary_key";
		$$var = $name;
	} else {
		my $var = (ref($class) || $class) ."::primary_key";
		return $$var;
	}
}

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
   $self->_do_query($insert);
}

sub update {
   my ($self) = @_;

   my $update = DM4P::SQL::Query::UPDATE->new()
                                       ->table($self->table);
   $update->where('#' . $self->table . '.#' . $self->primary_key . ' = ?');

   $self->_do_query($update, 1);
}

sub _do_query {
   my ($self, $query, $do_update) = @_;

   for my $key (keys %{$self->{'__data'}}) {
      $query->$key($self->{'__data'}->{$key});
   }

   my $db = DM4P::get_connection();
   my $stm = $db->get_statement($query);

   if($do_update) {
      $stm->bind(1, $self->{'__data'}->{$self->primary_key});
   }

   $stm->execute;
}

1;
