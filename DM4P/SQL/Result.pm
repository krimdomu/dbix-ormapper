package DM4P::SQL::Result;

use strict;
use warnings;

use DM4P::Exception::SQL::ColumnNotFound;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------

# Function: new
#
#   Creates an new DM4P::SQL::Result Object.
#
# Returns:
#
#   DM4P::SQL::Result
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = shift;
   
   bless($self, $proto);
   return $self;
}


# ------------------------------------------------------------------------------
# Group: AUTOLOAD
# ------------------------------------------------------------------------------

# Function: AUTOLOAD
#
#   Handles requests like $OBJ->col_name
sub AUTOLOAD {
   use vars qw($AUTOLOAD);
   my $self = shift;
   
   return $self if( $AUTOLOAD =~ m/DESTROY/ );
   
   $AUTOLOAD =~ m/^DM4P::SQL::Result::(.*?)$/;
   
   if(!defined $self->{$1}) {
      my $col = $1;
      DM4P::Exception::SQL::ColumnNotFound->throw(error => 'Column {' . $col . '} not found.');
   }
   return $self->{$1};
}

1;