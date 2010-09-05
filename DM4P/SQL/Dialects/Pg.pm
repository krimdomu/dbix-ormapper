package DM4P::SQL::Dialects::Pg;

use strict;
use warnings;

use DM4P::SQL::Dialects::Pg::SELECT;
use DM4P::SQL::Dialects::Pg::INSERT;
use DM4P::SQL::Dialects::Pg::DELETE;
use DM4P::SQL::Dialects::Pg::UPDATE;

use vars qw($JOIN);

$JOIN = {
   JOIN_LEFT    => 'LEFT JOIN "%s" ON %s',
   JOIN_NORMAL  => 'JOIN "%s" ON %s',
   JOIN_INNER   => 'INNER JOIN "%s" ON %s'
};


sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = {};
   
   bless($self, $proto);
   return $self;
}

sub parse_names {
   my $self = shift;
   my $str = shift;
   
   if($str =~ /^[a-zA-Z0-9_]+$/) {
      return '"' . $str . '"';
   }
   
   $str =~ s/#([a-zA-Z0-9_]+)/"$1"/gms;
   
   return $str;
}

sub parse_AS_names {
   my $self = shift;
   my $str = shift;
   
   $str = $self->parse_names($str);
   
   return ' AS ' . $str;
}

1;