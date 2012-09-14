package DBIx::ORMapper::SQL::Statement;

use strict;
use warnings;

use DBIx::ORMapper::SQL::ResultSet;

use DBIx::ORMapper::Exception::SQL;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------

# Function: new
#
#   Creates an new DBIx::ORMapper::SQL::Statement Object.
#
# Returns:
#
#   DBIx::ORMapper::SQL::Statement
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };
   
   bless($self, $proto);
   
   $self->{'__binds'} = [];
   $self->{'__query'}->class_type($self->db->class_type);
   
   return $self;
}

# Function: db
#
#    Returns the current database connection of this statement.
#
# Returns:
#
#   DBIx::ORMapper::Connection::Server
sub db {
   my $self = shift;
   return $self->{'db'};
}

# Function: bind
#
#    Bind the parameter to the query.
#
# Parameters:
#
#   Integer - Position.
#   Mixed - Value.
#   HashRef - Attributes.
sub bind {
   my $self = shift;
   push(@{$self->{'__binds'}}, [ @_ ]);
}

# Function: query
#
#    Set the query.
#
# Parameters:
#
#   DBIx::ORMapper::SQL::Query
#
# Returns:
#
#   DBIx::ORMapper::SQL::Query
sub query {
   my $self = shift;
   
   if(defined $_[0]) {
      $self->{'__query'} = shift;
      $self->{'__query'}->class_type($self->db->class_type);
   }
   
   return $self->{'__query'};
}

# Function: execute
#
#    Execute the query set by <setQuery>.
#
# Returns:
#
#    DBIx::ORMapper::SQL::ResultSet
sub execute {
   my $self = shift;

   if($ENV{"DEBUG"}) {
      print "SQL: " . $self->query->to_s . "\n";
   }

   $self->{'sth'} = $self->db->get_connection->prepare($self->query->to_s);
   if($self->query->has_bind) {
      if(scalar(@{$self->{'__binds'}}) > 0) {
         my @tmp = ();
         my @new_binds = @{$self->query->get_bind()};
         my $len = scalar(@new_binds);
         
         for my $v (@{$self->{'__binds'}}) {
            push(@tmp, [ $v->[0]+$len, $v->[1], (defined $v->[2]?$v->[2]:undef) ]);
         }
         
         $self->{'__binds'} = \@new_binds;
         push(@{$self->{'__binds'}}, @tmp);
      } else {
         $self->{'__binds'} = $self->query->get_bind; 
      }
   }

   for my $binds (@{$self->{'__binds'}}) {
      $self->{'sth'}->bind_param(@{$binds});
   }
   
   $self->{'sth'}->execute() or DBIx::ORMapper::Exception::SQL->throw(error => $self->{'sth'}->errstr . "\n\nSQL:\n" . $self->query->to_s . "\n"); 

   return DBIx::ORMapper::SQL::ResultSet->new(sth => $self);
}

# Function: finish
#
#    Finishs the current request.
sub finish {
   my $self = shift;
   $self->{'sth'}->finish();
   $self->{'__binds'} = [];
   $self->{'sth'} = undef;
}

# Function: fetchrow_hashref
#
#    Returns the Record as a HashRef.
#
# Returns:
#
#    HashRef.
sub fetchrow_hashref {
   my $self = shift;
   return $self->{'sth'}->fetchrow_hashref();
}

1;
