package DBIx::ORMapper::SQL::Query::CREATE;

use strict;
use warnings;

use DBIx::ORMapper::SQL::Query::FieldSet;

use base qw(DBIx::ORMapper::SQL::Query::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DBIx::ORMapper::SQL::Query::CREATE Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Query::CREATE
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
#   Add fields to the Table. Create a DBIx::ORMapper::SQL::Query::FieldSet Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Query::FieldList
sub fields {
   my $self = shift;
   
   $self->{'__fieldset'} = DBIx::ORMapper::SQL::Query::FieldSet->new(__query => $self);
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
   my @keys = @_;
   
   for my $k (@keys) {
      $self->{'__primary_key'} .= "#$k,";
   }

   $self->{'__primary_key'} =~ s/,$//;
   
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
