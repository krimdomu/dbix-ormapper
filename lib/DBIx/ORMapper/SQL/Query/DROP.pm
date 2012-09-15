#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package DBIx::ORMapper::SQL::Query::DROP;
   
use strict;
use warnings;

use base qw(DBIx::ORMapper::SQL::Query::Base);

sub new {
   my $that = shift;
   my $self = $that->SUPER::new(@_);

   return $self;
}

sub table {
   my $self = shift;

   $self->{'__table'} = shift;
   $self->{'__action'} = 'TABLE';

   return $self;
}

sub __get_sql {
   my $self = shift;

   my $class = $self->get_class("DROP");

   my $str = "DROP " . $class->get_action($self->{'__action'}) . " ";

   if($self->{'__action'} eq "TABLE") {
      $str .= $class->get_table($self->{'__table'});
   }

   return $self->SUPER::__get_sql($class, $str);
}

1;
