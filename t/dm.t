use strict;
use warnings;

use Test::More tests => 5;
use Data::Dumper;

use_ok 'DBIx::ORMapper::DM';
use_ok 'DBIx::ORMapper::DM::DataSource';

my $ds = DBIx::ORMapper::DM::DataSource->new;
ok(ref($ds), "datasource object created");

ref($ds)->attr("id", "Integer");
ref($ds)->attr("name", "String");

my @fields = ref($ds)->get_fields;
ok($fields[0]->[0] eq "#id", "got id field");
ok($fields[1]->[0] eq "#name", "got name field");

