package DM4P::SQL::Query::CREATE;

use strict;
use warnings;

use DM4P::SQL::Query::FieldSet;

use base qw(DM4P::SQL::Query::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DM4P::SQL::Query::CREATE Object.
#
# Returns:
#
#   DM4P::SQL::Query::CREATE
sub new {
   my $that = shift;
   my $self = $that->SUPER::new(@_);
   
   $self->{'__table'} = "";
   
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

# Function: fields
#
#   Add fields to the Table. Create a DM4P::SQL::Query::FieldSet Object.
#
# Returns:
#
#   DM4P::SQL::Query::FieldList
sub fields {
   my $self = shift;
   
   $self->{'__fieldset'} = DM4P::SQL::Query::FieldSet->new(__create_query => $self);
   return $self->{'__fieldset'};
}

# Function: primary_key
#
#   Set the primary key.
#
# Parameters:
#
#   String - Key
#
# Returns:
#
#   $self
sub primary_key {
   my $self = shift;
   
   $self->{'__primary_key'} = shift;
   
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
   
   my $str = "CREATE TABLE ";
   
   my $class = $self->get_class("CREATE");
   
   $str .= $class->get_table($self->{'__table'});
   $str .= " (";
   my $fields = "";
   
   for my $field (@{$self->{'__fieldset'}->get_fields()}) {
      if($fields ne "") { $fields .= ", "; }
      my $field_name = '#' . $field->{'name'};
      my $field_type = $class->get_field_type($field->{'type'}, $field->{'args'});
      $fields .= $field_name . ' ' . $field_type;
   }
   
   $str .= $fields;
   if(defined $self->{'__primary_key'} && $self->{'__primary_key'}) {
      $str .= ", " . $class->get_primary_key($self->{'__primary_key'});
   }
   
   $str .= ")";
   
   return $self->SUPER::__get_sql($class, $str);
}
1;