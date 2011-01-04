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

__PACKAGE__->belongs_to('User' => 'User', 'user_id', { auto_join => 1 });

sub blub {
   my ($self) = @_;
   $self->id;
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

__PACKAGE__->has_n('Notes' => 'Note', 'user_id', { auto_join => 1 });

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

#my $q = Note->all( (Note->id == 0) | (Note->id < 2) );
my $q = User->all( User->id == 1 );

print $q . "\n";

while(my $res1 = $q->next()) {
	print "Id: " . $res1->id . "\n";
	print "Username: " . $res1->name . "\n";
   my $all_notes = $res1->Notes;
   print "all_notes: $all_notes\n";
   while(my $notes = $all_notes->next) {
      print "Id: " . $notes->id . "\n";
   }
}

print "End\n";

#my $new_note = Note->new(
#                     id => 5,
#                     title => 'New Title 2',
#                     user_id => 1
#                  );
#my $new_note = Note->all( Note->id == 5 )->next;
#$new_note->title = "Updated title";
#$new_note->update;

#$new_note->save;

