package DM4P::SQL::Dialects::Pg::SELECT;

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
   
   for my $f (@_) {
      my($key, $val) = %{$f};
      
      if($str ne "") {
         $str .= ", ";
      }
      
      $str .= DM4P::SQL::Dialects::Pg::parse_names($key);
      $str .= DM4P::SQL::Dialects::Pg::parse_AS_names($val);
   }
   
   return $str;
}

# Function: get_join
#
#   Returns the SQL String for a join.
#
# Parameters:
#
#   DM4P::SQL::Query::SELECT::Join
#
# Returns:
#
#   String
sub get_join {
   shift;
   my $join = shift;
   
   my $str = "";
   
   $str = sprintf($DM4P::SQL::Dialects::Pg::JOIN->{$join->type}, 
         $join->{'__table'},
         DM4P::SQL::Dialects::Pg::parse_names($join->{'__on'})
      );
   
   return $str;
}

# Function: get_tables
#
#   Returns the SQL String for the tables.
#
# Parameters:
#
#   Tables as an Array.
#
# Returns:
# 
#   String
sub get_tables {
   return get_fields(@_);
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