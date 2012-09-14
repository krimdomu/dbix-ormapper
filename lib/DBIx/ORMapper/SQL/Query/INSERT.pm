package DBIx::ORMapper::SQL::Query::INSERT;

use strict;
use warnings;

use base qw(DBIx::ORMapper::SQL::Query::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DBIx::ORMapper::SQL::Query::INSERT Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Query::INSERT
sub new {
   my $that = shift;
   my $self = $that->SUPER::new(@_);
   
   @{$self->{'__fields'}} = ();
   $self->{'__table'} = "";
   
   $self->{'__has_bind'} = 1;
   
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
#   String - Table to insert data to.
#
# Returns:
#
#   $self
sub table {
   my $self = shift;
   
   $self->{'__table'} = shift;
   
   return $self;
}

# ------------------------------------------------------------------------------
# Group: AUTOLOAD
# ------------------------------------------------------------------------------

sub AUTOLOAD {
   use vars qw($AUTOLOAD);
   my $self = shift;
   
   return $self if( $AUTOLOAD =~ m/DESTROY/ );
   
   my($name) = ( $AUTOLOAD =~ m/^.*::(.*?)$/ );

   push(@{$self->{'__fields'}}, {
      name => $name,
      value => $_[0]
   });
   
   return $self;
}

# ------------------------------------------------------------------------------
# Group: Private
# ------------------------------------------------------------------------------

# Function: get_bind
#
#    Returns the INSERT values.
sub get_bind {
   my $self = shift;
   
   my @ret = ();
   
   my $i=0;
   for my $k (@{$self->{'__fields'}}) {
      $i++;
      push(@ret, [$i, $k->{'value'}]);
   }
   
   return \@ret;
}

# Function: __get_sql
#
#   Create the INSERT SQL Statement.
#
# Returns:
#
#   String
sub __get_sql {
   my $self = shift;
   
   my $str = "INSERT INTO ";
   
   my $class = $self->get_class("INSERT");
   
   $str .= $class->get_table($self->{'__table'});
   $str .= " (" . $class->get_fields(@{$self->{'__fields'}}) . ")";
   $str .= " VALUES(";
   
   my $q = "";
   for my $k (@{$self->{'__fields'}}) {
      if($q ne "") {
         $q .= ", ";
      }
      
      $q .= "?";
   }
   
   $str .= $q;
   $str .= ")";
   
   return $self->SUPER::__get_sql($class, $str);
}
1;
