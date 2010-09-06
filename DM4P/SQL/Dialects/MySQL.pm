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
   my $self = $that->SUPER::new(@_);
   
   $self->{'separator'} = '`';
   
   bless($self, $proto);
   return $self;
}

1;