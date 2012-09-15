package DBIx::ORMapper::SQL::Dialects::Base::ALTER;

use strict;
use warnings;

use base qw(DBIx::ORMapper::SQL::Dialects::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates an new DBIx::ORMapper::SQL::Dialects::Base::ALTER Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Dialects::Base::ALTER
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = {};
   
   bless($self, $proto);
   return $self;
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
