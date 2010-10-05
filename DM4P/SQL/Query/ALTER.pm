package DM4P::SQL::Query::ALTER;

use strict;
use warnings;

use DM4P::SQL::Query::FieldSet;

use base qw(DM4P::SQL::Query::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DM4P::SQL::Query::ALTER Object.
#
# Returns:
#
#   DM4P::SQL::Query::ALTER
sub new {
   my $that = shift;
   my $self = $that->SUPER::new(@_);
   
   $self->{'__table'} = "";
   $self->{'__foreign_keys'} = [];
   $self->{'__action'} = 'ADD'; # default action is add
   
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
#   String - Table to create.
#
# Returns:
#
#   $self
sub table {
   my $self = shift;
   
   $self->{'__table'} = shift;
   
   return $self;
}

# Function: foreign_key
#
#   Set Foreign Key of table.
#
# Parameters:
#
#   String  - Foreign Key.
#
# Returns:
#
#   $self
sub foreign_key {
   my $self = shift;
   
   push(@{$self->{'__foreign_keys'}}, {
      'key' => $_[0],
      'ref-table' => $_[1],
      'ref-col' => $_[2]
   });
   
   return $self;
}

# Function: add
#
#   ADD Alter Action.
#
# Returns:
#
#   $self
sub add {
   my $self = shift;
   
   $self->{'__action'} = 'ADD';
   
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
   
   my $str = "ALTER TABLE ";
   
   my $class = $self->get_class("ALTER");
   
   $str .= $class->get_table($self->{'__table'});
   $str .= ' ';
   $str .= $class->get_action($self->{'__action'});
   $str .= ' ';
   
   if(scalar(@{$self->{'__foreign_keys'}}) > 0) {
      for my $key (@{$self->{'__foreign_keys'}}) {
         $str .= ' ';
         $str .= $class->get_foreign_key($key);
      }
   }
   
   return $self->SUPER::__get_sql($class, $str);
}
1;