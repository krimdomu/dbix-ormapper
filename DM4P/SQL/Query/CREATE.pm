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
   $self->{'__index'} = "";
   $self->{'__index_column'} = [];
   $self->{'__action'} = 'TABLE';   # std action = TABLE
   
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
   $self->{'__action'} = 'TABLE';
   
   return $self;
}

# Function: index
#
#   Set the index action.
#
# Parameters:
#
#   String - Index Name.
#
# Returns:
#
#   $self
sub index {
   my $self = shift;
   
   $self->{'__index'} = shift;
   $self->{'__action'} = 'INDEX';
   
   return $self;
}

# Function: on
#
#   Set the on clause.
#
# Parameters:
#
#   String - Table.
#   String - Columns.
#
# Returns:
#
#   $self
sub on {
   my $self = shift;
   
   $self->{'__table'} = shift;
   
   if(ref($_[0]) eq "ARRAY") {
      $self->{'__index_column'} = shift;
   } else {
      $self->{'__index_column'} = [shift];
   }
   
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
   
   $self->{'__fieldset'} = DM4P::SQL::Query::FieldSet->new(__query => $self);
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
# Todo: Split class in 2 files for different actions.
#
# Returns:
#
#   String
sub __get_sql {
   my $self = shift;
   
   my $class = $self->get_class("CREATE");

   my $str = "CREATE " . $class->get_action($self->{'__action'} . " ");

   if($self->{'__action'} eq "TABLE") {
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
   } elsif($self->{'__action'} eq "INDEX") {
      $str .= ' ';
      $str .= $class->get_index($self->{'__index'});
      $str .= ' ON ';
      $str .= $class->get_table($self->{'__table'});
      $str .= ' (' . $class->get_index_column($self->{'__index_column'}) . ')'
   }
   
   return $self->SUPER::__get_sql($class, $str);
}
1;
