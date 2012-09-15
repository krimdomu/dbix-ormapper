package DBIx::ORMapper::SQL::Dialects::Base;

use strict;
use warnings;

use base qw(DBIx::ORMapper::SQL::Dialects::DialectBase);

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = {};
   
   bless($self, $proto);
   return $self;
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

1;
