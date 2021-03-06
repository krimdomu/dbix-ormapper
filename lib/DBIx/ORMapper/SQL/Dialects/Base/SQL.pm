package DBIx::ORMapper::SQL::Dialects::Base::SQL;

use strict;
use warnings;

use base qw(DBIx::ORMapper::SQL::Dialects::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates an new DBIx::ORMapper::SQL::Dialects::SQL Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Dialects::Base::SQL
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = {};
   
   bless($self, $proto);
   return $self;
}

# Function: get_sql
#
#   Returns the SQL String.
#
# Parameters:
#
#   String
#
# Returns:
#
#   String
sub get_sql {
   my $self = shift;
   my $sql = shift;
   
   my $str = $self->parse_names($sql);
   
   return $str;
}
1;
