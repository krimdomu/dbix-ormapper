package DBIx::ORMapper::DM::DataSource::Table;

use strict;
use warnings;

use base qw(DBIx::ORMapper::DM::DataSource);
use Data::Dumper;

use vars qw(%__join_key);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------

# Function: new
#
#   Creates an new DBIx::ORMapper::DM::DataSource::Table Object.
#
# Returns:
#
#   DBIx::ORMapper::DM::DataSource::Table
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
   my $opt = { @_ };

   my $select = DBIx::ORMapper::SQL::Query::SELECT->new()
      ->from($self->table)
      ->where($qry);

   if($opt->{"order_by"}) {
      my $order = $select->order($opt->{"order_by"});

      if($opt->{"order_direction"} && $opt->{"order_direction"} eq "asc") {
         $select = $order->asc();
      }
      elsif($opt->{"order_direction"} && $opt->{"order_direction"} eq "desc") {
         $select = $order->desc();
      }
      else {
         $select = $order->asc();
      }
   }

   if($opt->{"group_by"}) {
      $select->group($opt->{"group_by"});
   }

   if($opt->{"limit"}) {
      $select->limit($opt->{"limit"});
   }

   return $select;
}

sub table {
   my ($class, $name) = @_;
   no strict 'refs';

   if($name) {
      my $var = (ref($class) || $class ) ."::db_table";
      $$var = $name;
      my $tmp = $$var; # suppress warning
   } else {
      my $var = (ref($class) || $class) ."::db_table";
      return $$var;
   }
}

# ------------------------------------------------------------------------------
# Group: Overwritten DataSource Methods
# ------------------------------------------------------------------------------

sub find {
   my $self = shift;
   my $find = shift;

   my $pk = $self->primary_key;
   return DBIx::ORMapper::DM::Query->new(ds => $self, model => $self->model, $self->$pk == $find)->next;
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

sub get_join_key_for {
   my ($class, $obj) = @_;
   my $c = ref($class) || $class;
   return $__join_key{"$c|$obj"};
}

sub has_n {
   my ($class, $name, $join_pkg, $join_col, $opts) = @_;

   no strict 'refs';

   $__join_key{"$class|$join_pkg"} = $join_col;

   *{"${class}::$name"} = sub {
      my $self = shift;

      my $join_pkey = $join_pkg->primary_key;
      my $my_pkey   = $self->primary_key;
      return $join_pkg->all( $join_pkg->$join_col == $self->$my_pkey );
   };
}

sub has {
   my ($class) = shift;

   $class->has_n(@_);
}

sub belongs_to {
   my ($class, $name, $join_pkg, $join_col, $opts) = @_;

   no strict 'refs';

   $__join_key{"$class|$join_pkg"} = $join_col;

   *{"${class}::$name"} = sub {
      my $self = shift;

      my $join_pkey = $join_pkg->primary_key;
      my $my_pkey   = $self->primary_key;
      return $join_pkg->all( $join_pkg->$join_pkey == $self->$join_col );
   };
}

# ------------------------------------------------------------------------------
# Group: Datamanipulation
# ------------------------------------------------------------------------------

sub save {
   my ($self) = @_;

   my $insert = DBIx::ORMapper::SQL::Query::INSERT->new()
                                       ->table($self->table);
   $self->_do_query($insert);

   if(! $self->{__data}->{$self->primary_key}) {
      # if primary key is not set/loaded, load the complete record from db
      my $last_inserted_id_qry = DBIx::ORMapper::SQL::Query::LAST_INSERT_ID->new();
      my $res = $self->_execute_query($last_inserted_id_qry);
      my $row = $res->next;
      
      my $p_key = $self->primary_key;
      my $tmp_r = ref($self)->all( ref($self)->$p_key == $row->{id} );
      my $tmp = $tmp_r->next;
      $self->{__data} = $tmp->{__data};
   }
}

sub update {
   my ($self) = @_;

   my $update = DBIx::ORMapper::SQL::Query::UPDATE->new()
                                       ->table($self->table);
   $update->where('#' . $self->table . '.#' . $self->primary_key . ' = ?');

   $self->_do_query($update, 1);
}

sub delete {
   my ($self) = @_;

   my $delete = DBIx::ORMapper::SQL::Query::DELETE->new()
                                       ->table($self->table)
                                       ->where('#' . $self->table . '.#' . $self->primary_key . ' = ?');

   $self->_execute_query($delete, 1);
}

sub _do_query {
   my ($self, $query, $do_update) = @_;

   for my $key (keys %{$self->{'__data'}}) {
      $query->$key($self->{'__data'}->{$key});

      if($ENV{"DEBUG"}) {
         print "key: $key -> " . $self->{'__data'}->{$key} . "\n";
      }
   }

   $self->_execute_query($query, $do_update);
}

sub _execute_query {
   my ($self, $query, $do_bind_primary) = @_;

   my $db = $self->get_data_source;
   my $stm = $db->get_statement($query);

   if($do_bind_primary) {
      $stm->bind(1, $self->{'__data'}->{$self->primary_key});
   }

   $stm->execute;

}


1;
