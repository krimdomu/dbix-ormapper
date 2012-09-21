package DBIx::ORMapper::SQL::Table::Column::Type::Base;

use strict;
use warnings;

require Exporter;
use base qw(Exporter);

use vars qw(@EXPORT);
@EXPORT = qw(TIESCALAR FETCH STORE);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DBIx::ORMapper::SQL::Table::Column::Type::Base Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Table::Column::Type::Base
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };
   
   bless($self, $proto);
   
   return $self;
}

# Function: get_sql_type
#
#   Returns the SQL Type of the Column.
#
# Returns:
#
#   String
sub get_sql_type {
   my $self = shift;

   return $self->{'__sql_type'} 
      . ($self->{'size'}?'(' . $self->{'size'} . ')':'') # size
      . (exists $self->{'null'} && $self->{'null'}==0?' NOT NULL ':'') # null?
      . ($self->{'default'}?' DEFAULT ' . $self->get_default_value():'') # default value
      . $self->get_column_options();
}

# Function: get_default_value
#
#   Returns the default value.
#
# Returns:
#
#   String
sub get_default_value {
   my $self = shift;
   
   if($self->{'default'} =~ m/^\d+$/) {
      return $self->{'default'};
   }
   
   return "'" . $self->{'default'} . "'";
}

# Function: get_column_options
#
#   Returns optional column options. For create statements.
#
# Returns:
#
#   String
sub get_column_options {
   my $self = shift;
   return "";
}

# ------------------------------------------------------------------------------
# Group: Tie Functions
# ------------------------------------------------------------------------------
# Function: TIESCALAR
#
#   Creates the DBIx::ORMapper::SQL::Table::Column::Type::Base Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Table::Column::Type::Base
sub TIESCALAR {
   my ($class, $data) = @_;
   my $self = $class->new;
   $self->{'__data'} = $data;
   return $self;
}

sub FETCH {
   my ($self) = @_;
   return $self->{'__data'};
}

sub STORE {
   my ($self, $value) = @_;
   $self->{'__data'} = $value;
}


1;
