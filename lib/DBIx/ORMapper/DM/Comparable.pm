package DBIx::ORMapper::DM::Comparable;

use strict;
use warnings;

use Data::Dumper;

use overload 
   '>'  => sub  { $_[0]->overload_compare(@_, '>'); },
   '<'  => sub  { $_[0]->overload_compare(@_, '<'); },
   '==' => sub  { $_[0]->overload_compare(@_, '='); },
   '%'  => sub  { $_[0]->overload_compare(@_, ' LIKE '); },
   'eq' => sub  { $_[0]->overload_compare(@_, '='); };

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------

# Function: new
#
#   Creates an new DBIx::ORMapper::DM::Comparable Object.
#
# Returns:
#
#   DBIx::ORMapper::DM::Comparable
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

   if(ref($l) eq "DBIx::ORMapper::DM::Comparable") {
      $key = $l->key;
   } else {
      $key = $l;
   }

   if(ref($r) eq "DBIx::ORMapper::DM::Comparable") {
      $val = $l->key;
   } else {
      $val = $r;
   }

   return DBIx::ORMapper::DM::Query::Part->new(ds => $self->ds, 
                  model => $self->model, 
                  key => $key, 
                  val => $val, 
                  type => '', 
                  operator => $op);
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

sub ds {
   my $self = shift;
   return $self->{'ds'};
}

1;
