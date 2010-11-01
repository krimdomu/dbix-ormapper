use lib '../../../dm4p';
use lib '../../../dm4p-adapter-mysql';

package Note;

use strict;
use warnings;

use base qw(DM4P::DM::DataSource::Table);

__PACKAGE__->attr('id', 'Int');
__PACKAGE__->attr('title', 'String');
__PACKAGE__->attr('user_id', 'Int');

__PACKAGE__->table('notes');

1;

use strict;
use warnings;
use Data::Dumper;

use DM4P;
use DM4P::DM;
use DM4P::Adapter::MySQL;
use Exception::Class;

DM4P::setup(default => 'MySQL://localhost/' . $ARGV[0] . '?username=' . $ARGV[1] . '&password=' . $ARGV[2]);

my $db = DM4P::get_connection();
eval {
	$db->connect();
};

my $e;
if($e = Exception::Class->caught('DM4P::Exception::Connect')) {
	die("Error connecting to mysql server.");
}

my $qp = (Note->id > 0) & (Note->id < 2);
my $q = Note->all($qp);

print $q . "\n";

while(my $res1 = $q->next()) {
	print "Id: " . $res1->id . "\n";
	print "Title: " . $res1->title . "\n";
}

print "End\n";
