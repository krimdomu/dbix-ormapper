package DM4P::SQL::Query::FieldSet;

use strict;
use warnings;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DM4P::SQL::Query::FieldSet Object.
#
# Returns:
#
#   DM4P::SQL::Query::FieldSet
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };
   
   bless($self, $proto);
   
   $self->{'__fields'} = [];
   
   return $self;
}

# ------------------------------------------------------------------------------
# Group: Public
# ------------------------------------------------------------------------------

sub end {
   my $self = shift;
   return $self->__get_create_query();
}

# Function: get_fields
#
#   Returns the fields as an ArrayRef.
#
# Returns:
#
#    ArrayRef.
sub get_fields {
   my $self = shift;
   return $self->{'__fields'};
}

# ------------------------------------------------------------------------------
# Group: Private
# ------------------------------------------------------------------------------

# Function: __get_create_query
#
#   Returns the create query object.
#   For internal use only.
#
# Returns:
#
#    DM4P::SQL::Query::CREATE
sub __get_create_query {
   my $self = shift;
   return $self->{'__create_query'};
}

# ------------------------------------------------------------------------------
# Group: AUTOLOAD
# ------------------------------------------------------------------------------

sub AUTOLOAD {
   use vars qw($AUTOLOAD);
   my $self = shift;
   
   return $self if( $AUTOLOAD =~ m/DESTROY/ );
   
   $AUTOLOAD =~ m/^DM4P::SQL::Query::FieldSet::(.*?)$/;
   my $col_name = $1;
   my $col_type = shift;
   my $col_args = { @_ };
   
   push(@{$self->{'__fields'}}, {
      name => $col_name,
      type => $col_type,
      args => $col_args
   });

   return $self;
}

1;