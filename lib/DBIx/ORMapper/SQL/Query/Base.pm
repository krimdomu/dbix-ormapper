package DBIx::ORMapper::SQL::Query::Base;

use strict;
use warnings;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates an new DBIx::ORMapper::SQL::Query Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Query
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
   my $type = shift;
   
   my $class = "DBIx::ORMapper::SQL::Dialects::" . $self->class_type . "::$type";
   return $class->new();
}

# Function: has_bind
#
#   Internal Use Only.
sub has_bind {
   my $self = shift;
   return $self->{'__has_bind'};
}

# ------------------------------------------------------------------------------
# Group: Private
# ------------------------------------------------------------------------------

# Function: __get_sql
#
#   Create the INSERT SQL Statement.
#
# Parameters:
#
#   Dialect-Class
#   SQL String
#
# Returns:
#
#   String
sub __get_sql {
   my $self = shift;
   my $class = shift;
   my $str = shift;
   
   return $class->parse_names($str);
}

1;
