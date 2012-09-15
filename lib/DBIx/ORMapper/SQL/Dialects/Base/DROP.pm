package DBIx::ORMapper::SQL::Dialects::Base::DROP;

use strict;
use warnings;

use base qw(DBIx::ORMapper::SQL::Dialects::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates an new DBIx::ORMapper::SQL::Dialects::Base::CREATE Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Dialects::Base::CREATE
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = {};
   
   bless($self, $proto);
   return $self;
}
1;
