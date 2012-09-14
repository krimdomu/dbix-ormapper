package DBIx::ORMapper::Connection::Base;

use strict;
use warnings;

use URI;
use DBI;

use DBIx::ORMapper::SQL::Query::Base;
use DBIx::ORMapper::SQL::Query::SELECT;
use DBIx::ORMapper::SQL::Query::INSERT;
use DBIx::ORMapper::SQL::Query::DELETE;
use DBIx::ORMapper::SQL::Query::UPDATE;
use DBIx::ORMapper::SQL::Query::CREATE;
use DBIx::ORMapper::SQL::Query::ALTER;
use DBIx::ORMapper::SQL::Query::SQL;

use DBIx::ORMapper::SQL::Dialects::DialectBase;

use DBIx::ORMapper::SQL::Statement;

use DBIx::ORMapper::Exception::Connect;
use DBIx::ORMapper::Exception::KeyNotFound;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DBIx::ORMapper::Connection::Base Object.
#
# Returns:
#
#   DBIx::ORMapper::Connection::Base
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
   $db =~ s/^\///;
   
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

# Function: connect
#
#   Do some Adapter agnostic connection things.
sub connect {
   my $self = shift;

   if($self->uri =~ m/characterEncoding=([a-zA-Z0-9_\-]+)/) {
      $self->set_character_encoding($1);
   }
}

# Function: set_character_encoding
#   
#   Set the character encoding of the database connection. 
#   This function must be implemented by the adapter.
#
# Parameters:
#
#    String
sub set_character_encoding {
   my $self = shift;
   my $enc  = shift;
}

# Function: get_statement
#
#   Returns a DBIx::ORMapper::SQL::Statement Object to query the current database.
#
# Parameters:
#
#    DBIx::ORMapper::SQL::Query Object
#
# Returns:
#
#   DBIx::ORMapper::SQL::Statement
sub get_statement {
   my $self = shift;
   
   return DBIx::ORMapper::SQL::Statement->new(db => $self, __query => $_[0]);
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
   if(!$qry) { return undef; }
   
   for my $t (split(/[&;]/, $qry)) {
      my($key, $val) = split(/=/, $t);
      
      if($key eq $what) { return $val; }
   }
   
   eval { DBIx::ORMapper::Exception::KeyNotFound->throw(error => 'Key {' . $what . '} not found'); };
}
1;
