package DM4P::Exception::Connect;

use strict;
use warnings;

use Exception::Class::Base;

use base qw(Exception::Class::Base);

sub new {
   my $that = shift;
   my $self = $that->SUPER::new(@_);
   
   return $self;
}


1;