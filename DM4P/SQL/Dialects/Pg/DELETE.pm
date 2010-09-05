package DM4P::SQL::Dialects::Pg::DELETE;

use strict;
use warnings;

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
   
   return '"' . $t . '"';
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
   
   my $str = DM4P::SQL::Dialects::Pg::parse_names($where);
   
   return $str;
}

1;