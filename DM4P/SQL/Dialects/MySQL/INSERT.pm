package DM4P::SQL::Dialects::MySQL::INSERT;

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
   
   for my $k (@_) {
      if($str ne "") {
         $str .= ", ";
      }
      
      $str .= '`' . $k->{'name'} . '`';
   }
   
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

1;