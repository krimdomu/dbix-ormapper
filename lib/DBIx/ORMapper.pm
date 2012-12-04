package DBIx::ORMapper;

use strict;
use warnings;

use DBIx::ORMapper::Connection::Base;
use DBIx::ORMapper::Exception::Connect;
use DBIx::ORMapper::Exception::ConnectionNotFound;

our $VERSION='0.0.2';

use vars qw(%connections);

# Function: setup
#
#   Setup a Database Connection.
#
# Parameters:
#
#   String - Connection-String. Ex.: mysql://localhost/mydb?username=user&password=pass
sub setup {
   my $data = { @_ };
   
   for my $key (keys %{$data}) {
      $connections{$key} = DBIx::ORMapper::create_connection($data->{$key});
   }
}

# Function: create_connection
#
#   Internal used function.
#
# Parameters:
#
#   String - Connection-String.
#
# Returns:
#
#   DBIx::ORMapper::Connection::Server
sub create_connection {
   my $conn_str = shift;
   
   my ($db) = ($conn_str =~ m/^(.*?):/);
  
   if(!$db) {
      DBIx::ORMapper::Exception::Connect->throw(error => 'No Databasetype defined.');
   }
   
   my $type = $db;
   
   my $class_name = "DBIx::ORMapper::Connection::Server::$type";
   return $class_name->new(uri => $conn_str);
}

# Function: get_connection
#
#   Get a connection setup bei <setup>.
#
#   Throws Error::Simple if connection is not found.
#
# Parameters:
#
#   String - Connection Name.
#
# Returns:
#
#   DBIx::ORMapper::Connection::Server
sub get_connection {
   if(defined $_[0]) {
      if(defined $connections{$_[0]}) {
         return $connections{$_[0]}; 
      } else
      {
         DBIx::ORMapper::Exception::ConnectionNotFound->throw(error => 'Connection {' . $_[0] . '} not found.');
      }
   }
   
   if(!defined($connections{'default'})) {
         DBIx::ORMapper::Exception::ConnectionNotFound->throw(error => 'Connection {default} not found.');
   }
   return $connections{'default'};
}

1;
