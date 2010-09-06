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
   my $self = $that->SUPER::new(@_);
   
   $self->{'separator'} = '"';
   
   bless($self, $proto);
   return $self;
}

1;