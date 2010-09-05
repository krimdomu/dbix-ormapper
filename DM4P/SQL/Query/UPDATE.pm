package DM4P::SQL::Query::UPDATE;

use strict;
use warnings;

use base qw(DM4P::SQL::Query::Base);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DM4P::SQL::Query::UPDATE Object.
#
# Returns:
#
#   DM4P::SQL::Query::UPDATE
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

# Function: set
#
#    Dummy Function, only returns $self.
#
# Returns:
#
#    $self
sub set {
   my $self = shift;
   return $self;
}

# Function: where
#
#   
sub where {
   my $self = shift;
   $self->{'__where'} = shift;
   
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
#   Create the SELECT SQL Statement.
#
# Returns:
#
#   String
sub __get_sql {
   my $self = shift;
   
   my $str = "UPDATE ";
   
   my $class = $self->get_class("UPDATE");
   
   $str .= $class->get_table($self->{'__table'});
   $str .= " SET ";
   $str .= $class->get_update_fields($self->{'__fields'});
   
   if($self->{'__where'}) {
      $str .= " WHERE ";
      $str .= $class->get_where($self->{'__where'});
   }
   
   return $str;
}
1;