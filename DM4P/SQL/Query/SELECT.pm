package DM4P::SQL::Query::SELECT;

use strict;
use warnings;

use base qw(DM4P::SQL::Query::Base);

use DM4P::SQL::Query::SELECT::Join;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DM4P::SQL::Query::SELECT Object.
#
# Returns:
#
#   DM4P::SQL::Query::SELECT
sub new {
   my $that = shift;
   my $self = $that->SUPER::new(@_);
   
   @{$self->{'__fields'}} = ();
   @{$self->{'__tables'}} = ();
   @{$self->{'__joins'}}  = ();
   
   return $self;
}

# ------------------------------------------------------------------------------
# Group: Public
# ------------------------------------------------------------------------------

# Function: field
#
#   Set a field to select.
#
# Parameters:
#
#   String - Field to select.
#
# Returns:
#
#   $self
sub field {
   my $self = shift;
   
   $self->__push_data('__fields', @_);
   
   return $self;
}


# Function: from
#
#   Set the Table to select from.
#
# Parameters:
#
#   String - Table
#
# Returns:
#
#   $self
sub from {
   my $self = shift;
   
   $self->__push_data('__tables', @_);
   
   return $self;
}

# Function: where
#
#   
sub where {
   my $self = shift;
   $self->{'__where'} = shift;
   
   return $self;
}

# Function: join
#
#   Define a join.
#
# Parameters:
#
#   String - Table to join.
#
# Returns:
#
#   DM4P::SQL::Query::SELECT::Join
sub join {
   my $self = shift;
   
   my $join = DM4P::SQL::Query::SELECT::Join->new( query => $self, __table => $_[0] );
   push(@{$self->{'__joins'}}, $join);
   
   return $join;
}

# ------------------------------------------------------------------------------
# Group: Private
# ------------------------------------------------------------------------------

# Function: __push_data
#
#   internal function.
sub __push_data {
   my $self = shift;
   my $to = shift;
   
   my $key = $_[0];
   my $as  = $_[0];
   
   if(scalar(@_) == 2) {
      $as = $_[1];
   }
   
   push(@{$self->{$to}}, 
      {
        $key => $as
      }
   );
}

# Function: __get_sql
#
#   Create the SELECT SQL Statement.
#
# Returns:
#
#   String
sub __get_sql {
   my $self = shift;
   
   my $str = "SELECT ";
   
   my $class = $self->get_class("SELECT");
   
   $str .= $class->get_fields(@{$self->{'__fields'}});
   $str .= " FROM ";
   $str .= $class->get_tables(@{$self->{'__tables'}});
   
   if(scalar(@{$self->{'__joins'}}) > 0) {
      $str .= ' ';
      for my $j (@{$self->{'__joins'}}) {
         $str .= $class->get_join($j);
      }
   }
   
   $str .= " WHERE ";
   $str .= $class->get_where($self->{'__where'});
   
   return $self->SUPER::__get_sql($class, $str);
}
1;