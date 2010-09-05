package DM4P::SQL::Dialects::Base;

use strict;
use warnings;

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
      return $self->{'separator'} . $str . $self->{'separator'};
   }
   
   my $sep = $self->{'separator'};
   $str =~ s/#([a-zA-Z0-9_]+)/$sep$1$sep/gms;
   
   return $str;
}

sub parse_AS_names {
   my $self = shift;
   my $str = shift;
   
   $str = $self->parse_names($str);
   
   return ' AS ' . $str;
}

1;