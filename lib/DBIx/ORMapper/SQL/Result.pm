package DBIx::ORMapper::SQL::Result;

use strict;
use warnings;

use DBIx::ORMapper::Exception::SQL::ColumnNotFound;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------

# Function: new
#
#   Creates an new DBIx::ORMapper::SQL::Result Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Result
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = shift;
   
   if(!$self) { return undef; }
   
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
   
   $AUTOLOAD =~ m/^DBIx::ORMapper::SQL::Result::(.*?)$/;
   
   if(!defined $self->{$1}) {
      my $col = $1;
      DBIx::ORMapper::Exception::SQL::ColumnNotFound->throw(error => 'Column {' . $col . '} not found.');
   }
   return $self->{$1};
}

1;
