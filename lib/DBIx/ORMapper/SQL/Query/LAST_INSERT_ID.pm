package DBIx::ORMapper::SQL::Query::LAST_INSERT_ID;

use strict;
use warnings;

use base qw(DBIx::ORMapper::SQL::Query::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DBIx::ORMapper::SQL::Query::LAST_INSERT_ID Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Query::LAST_INSERT_ID
sub new {
   my $that = shift;
   my $self = $that->SUPER::new(@_);
   
   return $self;
}

sub __get_sql {

   my $self = shift;
   
   my $class = $self->get_class("LAST_INSERT_ID");

   return $class->__get_sql;
 
}

1;
