package DBIx::ORMapper::SQL::Dialects::DialectBase;

use strict;
use warnings;

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

sub parse_names {
   my $self = shift;
   my $str = shift;
   
   if($str =~ /^[a-zA-Z0-9_]+$/) {
      return $self->{'separator'} . $str . $self->{'separator'};
   }
   
   my $sep = $self->{'separator'};
   $str =~ s/#([a-zA-Z0-9_]+)/$sep$1$sep/gms;
   
   return $str;
}


1;
