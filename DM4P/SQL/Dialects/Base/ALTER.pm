package DM4P::SQL::Dialects::Base::ALTER;

use strict;
use warnings;

use base qw(DM4P::SQL::Dialects::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates an new DM4P::SQL::Dialects::Base::ALTER Object.
#
# Returns:
#
#   DM4P::SQL::Dialects::Base::ALTER
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

# Function: get_action
#
#   Returns the ALTER action.
#
# Parameters:
#
#   String - Action.
#
# Returns:
#
#   String
sub get_action {
   my $self = shift;
   
   my $action = shift;
   
   return $action;
}

# Function: get_foreign_key
#
#   Returns the foreign key string.
#
# Parameters:
#
#   key.key - String, Column Names.
#   key.ref-table - Reference Table.
#   key.ref-col - Reference Colum(s)
#
# Returns:
#
#   String
sub get_foreign_key {
   my $self = shift;
   my $key = shift;
   
   return ' FOREIGN KEY (' . $key->{'key'} . ') REFERENCES #' . $key->{'ref-table'} . ' (' . $key->{'ref-col'} . ')';
}

1;