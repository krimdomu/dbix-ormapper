package DM4P::SQL::Query::DELETE;

use strict;
use warnings;

use base qw(DM4P::SQL::Query::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DM4P::SQL::Query::DELETE Object.
#
# Returns:
#
#   DM4P::SQL::Query::DELETE
sub new {
   my $that = shift;
   my $self = $that->SUPER::new(@_);
   
   $self->{'__where'} = "";
   $self->{'__table'} = "";
   
   return $self;
}

# ------------------------------------------------------------------------------
# Group: Public
# ------------------------------------------------------------------------------

# Function: table
#
#   Set the table.
#
# Parameters:
#
#   String - Table to insert data to.
#
# Returns:
#
#   $self
sub table {
   my $self = shift;
   
   $self->{'__table'} = shift;
   
   return $self;
}

# Function: where
#
#   
sub where {
   my $self = shift;
   $self->{'__where'} = shift;
   
   return $self;
}

# ------------------------------------------------------------------------------
# Group: Private
# ------------------------------------------------------------------------------


# Function: __get_sql
#
#   Create the SELECT SQL Statement.
#
# Returns:
#
#   String
sub __get_sql {
   my $self = shift;
   
   my $str = "DELETE FROM ";
   
   my $class = $self->get_class("DELETE");
   
   $str .= $class->get_table($self->{'__table'});
   $str .= " WHERE ";
   $str .= $class->get_where($self->{'__where'});
   
   return $self->SUPER::__get_sql($class, $str);
}
1;