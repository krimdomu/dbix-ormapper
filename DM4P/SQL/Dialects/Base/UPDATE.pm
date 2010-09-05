package DM4P::SQL::Dialects::Base::UPDATE;

use strict;
use warnings;

use base qw(DM4P::SQL::Dialects::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates an new DM4P::SQL::Query Object.
#
# Returns:
#
#   DM4P::SQL::Dialects::MySQL::UPDATE
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

# Function: get_table
#
#   Returns the SQL String for the tables.
#
# Parameters:
#
#   String - Table
#
# Returns:
# 
#   String
sub get_table {
   my $self = shift;
   
   my $t = shift;
   
   return $self->{'separator'} . $t . $self->{'separator'};
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
      $str .= $self->{'separator'} . $k->{'name'} . $self->{'separator'} . '=?';
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