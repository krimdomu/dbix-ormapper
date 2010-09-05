package DM4P::SQL::Dialects::MySQL::UPDATE;

use strict;
use warnings;

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
   shift;
   
   my $t = shift;
   
   return '`' . $t . '`';
}

# Function: get_update_string
#
#   
sub get_update_fields {
   shift;
   my $fields = shift;
   my $str = "";
   
   for my $k (@{$fields}) {
      if($str ne "") {
         $str .= ", ";
      }
      $str .= '`' . $k->{'name'} . '`=?'
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
   shift;
   my $where = shift;
   
   my $str = DM4P::SQL::Dialects::MySQL::parse_names($where);
   
   return $str;
}

1;