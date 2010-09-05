package DM4P::SQL::Dialects::Pg;

use strict;
use warnings;

use DM4P::SQL::Dialects::Pg::SELECT;
use DM4P::SQL::Dialects::Pg::INSERT;
use DM4P::SQL::Dialects::Pg::DELETE;
use DM4P::SQL::Dialects::Pg::UPDATE;

use base qw(DM4P::SQL::Dialects::DialectBase);

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = {};
   
   $self->{'separator'} = '"';
   $self->{'JOIN'} = {
      JOIN_LEFT    => 'LEFT JOIN #%s ON %s',
      JOIN_NORMAL  => 'JOIN #%s ON %s',
      JOIN_INNER   => 'INNER JOIN #%s ON %s'
   };
   
   bless($self, $proto);
   return $self;
}

1;