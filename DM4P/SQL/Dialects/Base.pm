package DM4P::SQL::Dialects::Base;

use strict;
use warnings;

use vars qw($JOIN);

$JOIN = {
   JOIN_LEFT    => 'LEFT JOIN #%s ON %s',
   JOIN_NORMAL  => 'JOIN #%s ON %s',
   JOIN_INNER   => 'INNER JOIN #%s ON %s'
};

sub parse_names {
   my $str = shift;
   my $sep = shift;
   
   if($str =~ /^[a-zA-Z0-9_]+$/) {
      return $sep . $str . $sep;
   }
   
   $str =~ s/#([a-zA-Z0-9_]+)/$sep$1$sep/gms;
   
   return $str;
}

sub parse_AS_names {
   my $str = shift;
   
   $str = parse_names($str);
   
   return ' AS ' . $str;
}

1;