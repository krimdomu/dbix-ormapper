package DBIx::ORMapper::Exception::SQL::ColumnNotFound;

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
