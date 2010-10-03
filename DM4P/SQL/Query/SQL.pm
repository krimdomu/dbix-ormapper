package DM4P::SQL::Query::SQL;

use strict;
use warnings;

use base qw(DM4P::SQL::Query::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DM4P::SQL::Query::SQL Object.
#
# Returns:
#
#   DM4P::SQL::Query::SQL
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = $that->SUPER::new(@_);
   
   bless($self, $proto);
   
   $self->{'__query'} = '';
   
   return $self;
}

# ------------------------------------------------------------------------------
# Group: Public
# ------------------------------------------------------------------------------

# Function: query
#
#   Set the query to execute.
#
# Parameters:
#
#   String - Query to execute
#
# Returns:
#
#   $self
sub query {
   my $self = shift;
   
   $self->{'__query'} = shift;
   
   return $self;
}


# Function: __get_sql
#
#   Create the SELECT SQL Statement.
#
# Returns:
#
#   String
sub __get_sql {
   my $self = shift;
   
   my $str = "SELECT ";
   
   my $class = $self->get_class("SQL");
   
   return $self->SUPER::__get_sql($class, $self->{'__query'});
}
1;