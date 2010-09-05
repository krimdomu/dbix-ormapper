package DM4P;

use strict;
use warnings;

use Error qw(:try);

use DM4P::Connection::Base;

use vars qw(%connections %conn_map);

%conn_map = (
   'mysql'  => 'MySQL'
);

# Function: setup
#
#   Setup a Database Connection.
#
# Parameters:
#
#   String - Connection-String. Ex.: mysql://localhost/mydb?username=user&password=pass
sub setup {
   my $data = { @_ };
   my @keys = keys %{$data};
   
   $connections{$keys[0]} = DM4P::create_connection($data->{$keys[0]});
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
#   DM4P::Connection::Server
sub create_connection {
   my $conn_str = shift;
   
   my ($db) = ($conn_str =~ m/^(.*?):/);
  
   if(!$db) {
      throw Error::Simple -text => 'No Database Type set.';
   }
   
   my $type = $conn_map{$db};
   require "DM4P/SQL/Dialects/$type.pm";
   require "DM4P/Connection/Server/$type.pm";
   
   my $class_name = "DM4P::Connection::Server::$type";
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
#   DM4P::Connection::Server
sub get_connection {
   if(defined $_[0]) {
      if(defined $connections{$_[0]}) {
         return $connections{$_[0]}; 
      } else
      {
         throw Error::Simple -text => 'No Connection found';
      }
   }
   
   if(!defined($connections{'default'})) {
      throw Error::Simple -text => 'No Connection found';
   }
   return $connections{'default'};
}

1;