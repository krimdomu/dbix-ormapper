package DM4P::SQL::Query::Base;

use strict;
use warnings;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates an new DM4P::SQL::Query Object.
#
# Returns:
#
#   DM4P::SQL::Query
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = {};
   
   $self->{'__has_bind'} = 0;
   
   bless($self, $proto);
   return $self;
}

# Function: class_type
#
#    Get and set the Class Type.
#    Internal use only.
sub class_type {
   my $self = shift;
   
   if(defined($_[0])) {
      $self->{'__type'} = shift;
   }
   
   return $self->{'__type'};
}

# Function: to_s
#
#   Returns the SQL String.
#
# Returns:
#
#    String
sub to_s {
   my $self = shift;
   
   if(defined($_[0])) {
      $self->class_type($_[0]);
   }
   
   return $self->__get_sql();
}

# Function: get_class
#
#    Internal Use Only.
sub get_class {
   my $self = shift;
   
   return "DM4P::SQL::Dialects::" . $self->class_type . "::";
}

# Function: has_bind
#
#   Internal Use Only.
sub has_bind {
   my $self = shift;
   return $self->{'__has_bind'};
}

1;