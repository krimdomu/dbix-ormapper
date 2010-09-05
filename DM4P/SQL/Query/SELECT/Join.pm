package DM4P::SQL::Query::SELECT::Join;

use strict;
use warnings;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DM4P::SQL::Query::SELECT::Join Object.
#
# Returns:
#
#   DM4P::SQL::Query::SELECT::Join
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };
   
   $self->{'__on'} = "";
   
   bless($self, $proto);
   return $self;
}

# Function: query
#
#    Returns the current query.
#
# Returns:
#
#   DM4P::SQL::Query::SELECT
sub query {
   my $self = shift;
   return $self->{'query'};
}

# Function: type
#
#   Returns the Join type.
#
# Returns:
#
#   String
sub type {
   my $self = shift;

   return "JOIN_LEFT";
}

# Function: on
#
#    Define the ON clause.
#
# Returns:
#
#    DM4P::SQL::Query::SELECT
sub on {
   my $self = shift;
   $self->{'__on'} = $_[0];
   
   return $self->query;
}

1;