package DBIx::ORMapper::SQL::Query::ALTER;

use strict;
use warnings;

use DBIx::ORMapper::SQL::Query::FieldSet;

use base qw(DBIx::ORMapper::SQL::Query::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DBIx::ORMapper::SQL::Query::ALTER Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Query::ALTER
sub new {
   my $that = shift;
   my $self = $that->SUPER::new(@_);
   
   $self->{'__table'} = "";
   $self->{'__foreign_keys'} = [];
   $self->{'__action'} = 'ADD'; # default action is add
   $self->{'__column'} = 0;
   
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

# Function: drop
#
#   DROP Alter Action.
#
# Returns:
#
#   $self
sub drop {
   my $self = shift;
   
   $self->{'__action'} = 'DROP';
   
   return $self;
}

# Function: modify
#
#   Modify a colum of a table.
#
# Returns:
#
#   $self
sub modify {
   my $self = shift;

   $self->{'__action'} = 'MODIFY';

   return $self;
}

# Function: column
#
#   Add a column to the table.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Query::FieldSet
sub column {
   my $self = shift;
   
   $self->{'__column'} = 1;
   $self->{'__fieldset'} = DBIx::ORMapper::SQL::Query::FieldSet->new(__query => $self);
   return $self->{'__fieldset'};
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
   
   if($self->{'__column'} == 1) {
      my $fields = "";
      $str .= ' COLUMN ';
      for my $field (@{$self->{'__fieldset'}->get_fields()}) {
         if($fields ne "") { $fields .= ", "; }
         my $field_name = '#' . $field->{'name'};
         my $field_type = $class->get_field_type($field->{'type'}, $field->{'args'});
         $fields .= $field_name . ' ' . ($field_type || '');
      }
      
      $str .= $fields;
   }
      
   if(scalar(@{$self->{'__foreign_keys'}}) > 0) {
      for my $key (@{$self->{'__foreign_keys'}}) {
         $str .= ' ';
         $str .= $class->get_foreign_key($key);
      }
   }
   
   return $self->SUPER::__get_sql($class, $str);
}
1;
