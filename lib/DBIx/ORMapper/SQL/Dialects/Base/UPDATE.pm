package DBIx::ORMapper::SQL::Dialects::Base::UPDATE;

use strict;
use warnings;

use base qw(DBIx::ORMapper::SQL::Dialects::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates an new DBIx::ORMapper::SQL::Query Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Dialects::MySQL::UPDATE
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = {};
   
   bless($self, $proto);
   return $self;
}

# Function: get_fields
#
#   Returns the SQL String for the fields.
#
# Parameters:
#
#   Fields as an Array.
#
# Returns:
# 
#   String
sub get_fields {
   shift;
   my $str = "";
   
   
   return $str;
}


# Function: get_update_string
#
#   
sub get_update_fields {
   my $self = shift;
   my $fields = shift;
   my $str = "";
   
   for my $k (@{$fields}) {
      if($str ne "") {
         $str .= ", ";
      }
      $str .= "#" . $k->{'name'} . '=?';
   }
   
   return $str;
}

# Function: get_where
#
#   Returns the SQL String for WHERE clause.
#
# Parameters:
#
#   String
#
# Returns:
#
#   String
sub get_where {
   my $self = shift;
   my $where = shift;
   
   my $str = $self->parse_names($where);
   
   return $str;
}

1;
