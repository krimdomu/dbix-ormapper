package DM4P::Connection::Base;

use strict;
use warnings;

use URI;
use DBI;

use DM4P::SQL::Query::Base;
use DM4P::SQL::Query::SELECT;
use DM4P::SQL::Query::INSERT;
use DM4P::SQL::Query::DELETE;
use DM4P::SQL::Query::UPDATE;

use DM4P::SQL::Statement;

use DM4P::Exception::Connect;
use DM4P::Exception::KeyNotFound;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DM4P::Connection::Base Object.
#
# Returns:
#
#   DM4P::Connection::Base
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };
   
   bless($self, $proto);
   
   return $self;
}

# ------------------------------------------------------------------------------
# Group: Public
# ------------------------------------------------------------------------------

# Function: uri
#
#   Returns the complet connection uri.
#
# Returns:
#
#   String - Connection URI.
sub uri {
   my $self = shift;
   return $self->{'uri'};
}

# Function: db
#
#   Returns the name of the database.
#
# Returns:
#
#   String - Name of the database.
sub db {
   my $self = shift;
   my $u = URI->new($self->uri);
   
   my $db = $u->path;
   $db =~ s/\///gms;
   
   return $db;
}

# Function: server
#
#   Returns the Servername.
#
# Returns:
#
#   String - Servername.
sub server {
   my $self = shift;
   $self->uri =~ m/^.*?:\/\/(.*?)\//;
   
   return $1;
}

# Function: username
#
#   Returns the username.
#
# Returns:
#
#   String - Username.
sub username {
   my $self = shift;

   return $self->__get_from_uri('username');
}

# Function: password
#
#   Returns the password.
#
# Returns:
#
#   String - Password.
sub password {
   my $self = shift;

   return $self->__get_from_uri('password');
}

# Function: type
#
#    Returns the Database-Type.
#
# Returns:
#
#   String - Database-Type.
sub type {
   my $self = shift;
   my $u = URI->new($self->uri);
   
   return $DM4P::conn_map->{$u->scheme}->{'dbiclass'};
}

# Function: dsn
#
#   Returns the DBI compatible DSN String.
#
# Returns:
#
#   String - DBI DSN String.
sub dsn {
   my $self = shift;
   
   my $str = $self->{'dbi-type'} . ":"
            . $self->type() . ":"
            . "database="
            . $self->db() . ";"
            . "host="
            . $self->server();
            
   return $str;
}

# Function: get_statement
#
#   Returns a DM4P::SQL::Statement Object to query the current database.
#
# Parameters:
#
#    DM4P::SQL::Query Object
#
# Returns:
#
#   DM4P::SQL::Statement
sub get_statement {
   my $self = shift;
   
   return DM4P::SQL::Statement->new(db => $self, __query => $_[0]);
}

# Function: get_connection
#
#    Returns the DBI Connection.
#
# Returns:
#
#    DBI Connection.
sub get_connection {
   my $self = shift;
   return $self->{'__db_connection'};
}

# ------------------------------------------------------------------------------
# Group: Private
# ------------------------------------------------------------------------------
sub __get_from_uri {
   my $self = shift;
   my $what = shift;
   
   my $qry = [ split(/\?/, $self->uri) ]->[1];
   
   for my $t (split(/[&;]/, $qry)) {
      my($key, $val) = split(/=/, $t);
      
      if($key eq $what) { return $val; }
   }
   
   eval { DM4P::Exception::KeyNotFound->throw(error => 'Key {' . $what . '} not found'); };
}
1;