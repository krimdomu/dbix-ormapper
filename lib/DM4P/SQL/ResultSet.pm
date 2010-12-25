package DM4P::SQL::ResultSet;

use strict;
use warnings;

use DM4P::SQL::Result;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates an new DM4P::SQL::ResultSet Object.
#
# Returns:
#
#   DM4P::SQL::ResultSet
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };
   
   bless($self, $proto);
   return $self;
}

# ------------------------------------------------------------------------------
# Group: Public
# ------------------------------------------------------------------------------

# Function: get_all
#
#   Returns all rows in an array.
#
# Returns:
#
#   Array
sub get_all {
   my $self = shift;
   my @arr;
   
   while (my $ref = $self->{'sth'}->fetchrow_hashref()) {
      push(@arr, DM4P::SQL::Result->new($ref));
   }
   
   return @arr;
}

# Function: next
#
#   Returns the next row.
#
# Returns:
#
#   HashRef
sub next {
   my $self = shift;
   
   return DM4P::SQL::Result->new($self->{'sth'}->fetchrow_hashref());
}

# Function: each
#
#   Execute the given BLOCK on each Result.
#
# Parameters:
#
#   FunctionRef - Function Reference.
#
# Returns:
#
#   Number of runs.
sub each(&) {
   my $self = shift;
   my $code = shift;
   
   my $counter = 0;
   
   while (my $ref = $self->{'sth'}->fetchrow_hashref()) {
      &$code(DM4P::SQL::Result->new($ref), $counter);
      $counter++;
   }
   
   return $counter;
}

1;