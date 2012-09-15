package DBIx::ORMapper::SQL::Dialects::Base::CREATE;

use strict;
use warnings;

use base qw(DBIx::ORMapper::SQL::Dialects::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates an new DBIx::ORMapper::SQL::Dialects::Base::CREATE Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Dialects::Base::CREATE
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = {};
   
   bless($self, $proto);
   return $self;
}

# Function: get_index
#
#   Returns the indx.
#
# Parameters:
#
#   String - Name of the index.
#
# Returns:
#
#   String
sub get_index {
   my $self = shift;
   my $idx = shift;
   
   return '#'.$idx;
}

# Function: get_index_column
#
#   Returns the index columns
#
# Parameters:
#
#   ArrayRef - Columns
#
# Returns:
#
#   String
sub get_index_column {
   my $self = shift;
   my $col = shift;
   
   my @cols = @{$col};
   map { $_ = "#$_" } @cols;
   
   return join(', ', @cols);
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
