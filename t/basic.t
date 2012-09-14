package DBIx::ORMapper::Connection::Server::Test;

use base qw(DBIx::ORMapper::Connection::Base);

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   $self->{"dbi-type"} = "DBI";

   return $self;
}

sub type { return "test"; }

package main;

use strict;
use warnings;

use Test::More tests => 15;

use_ok 'DBIx::ORMapper';

DBIx::ORMapper::setup(

   default => "Test://localhost/mydb?username=user&password=pass",
   read    => "Test://foo/bardb?username=ro&password=passro",

);

ok(ref(DBIx::ORMapper::get_connection()) eq "DBIx::ORMapper::Connection::Server::Test", "got default connection");
ok(ref(DBIx::ORMapper::get_connection("default")) eq "DBIx::ORMapper::Connection::Server::Test", "got default connection (2)");
ok(ref(DBIx::ORMapper::get_connection("read")) eq "DBIx::ORMapper::Connection::Server::Test", "got read connection");

my $con = DBIx::ORMapper::get_connection();
my $con_read = DBIx::ORMapper::get_connection("read");

ok($con->db eq "mydb", "got db");
ok($con_read->db eq "bardb", "got read db");
ok($con->uri eq "Test://localhost/mydb?username=user&password=pass", "got uri");
ok($con->server eq "localhost", "got server");
ok($con_read->server eq "foo", "got server (read");

ok($con->username eq "user", "got username");
ok($con_read->username eq "ro", "got username (read");
ok($con->password eq "pass", "got password");
ok($con_read->password eq "passro", "got password (read");

ok($con->dsn eq "DBI:test:database=mydb;host=localhost", "got dsn");
ok($con_read->dsn eq "DBI:test:database=bardb;host=foo", "got dsn (read)");



