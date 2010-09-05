package DM4P::SQL::Dialects::MySQL;

use strict;
use warnings;

use DM4P::SQL::Dialects::MySQL::SELECT;
use DM4P::SQL::Dialects::MySQL::INSERT;
use DM4P::SQL::Dialects::MySQL::DELETE;
use DM4P::SQL::Dialects::MySQL::UPDATE;

use base qw(DM4P::SQL::Dialects::DialectBase);

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = {};
   
   $self->{'separator'} = '`';
   $self->{'JOIN'} = {
      JOIN_LEFT    => 'LEFT JOIN #%s ON %s',
      JOIN_NORMAL  => 'JOIN #%s ON %s',
      JOIN_INNER   => 'INNER JOIN #%s ON %s'
   };
   
   bless($self, $proto);
   return $self;
}

1;