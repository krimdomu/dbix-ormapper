use lib '../../../dm4p/lib';
use lib '../../../dm4p-adapter-mysql/lib';

package Note;

use strict;
use warnings;

use base qw(DM4P::DM::DataSource::Table);

__PACKAGE__->attr('id', 'Int');
__PACKAGE__->attr('title', 'String');
__PACKAGE__->attr('user_id', 'Int');

__PACKAGE__->table('notes');
__PACKAGE__->primary_key('id');

__PACKAGE__->belongs_to('User' => 'User', { auto_join => 1 });

sub blub {
   my ($self) = @_;
   return "die id: (" . $self->id . ")";
}

1;

package User;

use strict;
use warnings;

use base qw(DM4P::DM::DataSource::Table);

__PACKAGE__->attr('id', 'Int');
__PACKAGE__->attr('name', 'String');
__PACKAGE__->attr('password', 'String');
__PACKAGE__->attr('email', 'String');

__PACKAGE__->table('users');
__PACKAGE__->primary_key('id');

__PACKAGE__->has_n('Notes' => 'Note', { auto_join => 1 });

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

my $q = Note->all( (Note->id == 0) | (Note->id < 2) );

print $q . "\n";

while(my $res1 = $q->next()) {
	print "Id: " . $res1->id . "\n";
	print "Title: " . $res1->title . "\n";
   print $res1->blub . "\n";
}

print "End\n";

#my $new_note = Note->new(
#                     id => 5,
#                     title => 'New Title 2',
#                     user_id => 1
#                  );
my $new_note = Note->all( Note->id == 5 )->next;
$new_note->title = "Updated title";
$new_note->update;

#$new_note->save;

