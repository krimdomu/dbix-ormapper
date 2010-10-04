package DM4P::SQL::Dialects::Base::CREATE;

use strict;
use warnings;

use base qw(DM4P::SQL::Dialects::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates an new DM4P::SQL::Dialects::Base::CREATE Object.
#
# Returns:
#
#   DM4P::SQL::Dialects::Base::CREATE
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = {};
   
   bless($self, $proto);
   return $self;
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
   
   return "#$t";
}

# Function: get_field_type
#
#    Get Field Type.
#
# Returns:
#
#   String.
sub get_field_type {
   my $self = shift;
   
   # todo: throw MustOverride
}

# Function: get_primary_key
#
#    Get Primary Key.
#
# Returns:
#
#   String.
sub get_primary_key {
   my $self = shift;
   my $pri_key = shift;
   
   return 'PRIMARY KEY(' . $pri_key . ')';
}


1;