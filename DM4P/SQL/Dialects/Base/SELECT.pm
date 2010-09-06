package DM4P::SQL::Dialects::Base::SELECT;

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
#   DM4P::SQL::Dialects::MySQL::SELECT
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
   my $self = shift;
   my $str = "";

   for my $f (@_) {
      my($key, $val) = %{$f};
      
      if($str ne "") {
         $str .= ", ";
      }
      
      $str .= $key;
      $val =~ s/#//g;
      $str .= ' AS #' . $val;
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
   my $self = shift;
   my $join = shift;
   
   my $str = "";
   
   $str = sprintf($self->{JOIN}->{$join->type}, 
         $join->{'__table'},
         $join->{'__on'}
      );
   
   return $self->parse_names($str);
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
   my $self = shift;
   return $self->get_fields(@_);
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