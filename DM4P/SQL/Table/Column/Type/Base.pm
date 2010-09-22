package DM4P::SQL::Table::Column::Type::Base;

use strict;
use warnings;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DM4P::SQL::Table::Column::Type::Base Object.
#
# Returns:
#
#   DM4P::SQL::Table::Column::Type::Base
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };
   
   bless($self, $proto);
   
   return $self;
}

# Function: get_sql_type
#
#   Returns the SQL Type of the Column.
#
# Returns:
#
#   String
sub get_sql_type {
   my $self = shift;

   return $self->{'__sql_type'} 
      . ($self->{'size'}?'(' . $self->{'size'} . ')':'') # size
      . ($self->{'default'}?" DEFAULT " . $self->get_default_value():''); # default value
}

# Function: get_default_value
#
#   Returns the default value.
#
# Returns:
#
#   String
sub get_default_value {
   my $self = shift;
   
   if($self->{'default'} =~ m/^\d+$/) {
      return $self->{'default'};
   }
   
   return "'" . $self->{'default'} . "'";
}

1;