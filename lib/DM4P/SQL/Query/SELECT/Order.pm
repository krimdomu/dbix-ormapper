#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package DM4P::SQL::Query::SELECT::Order;

use strict;
use warnings;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------
# Function: new
#
#   Creates the DM4P::SQL::Query::SELECT::Order Object.
#
# Returns:
#
#   DM4P::SQL::Query::SELECT::Order
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };
   
   
   bless($self, $proto);
   return $self;
}

sub asc {
   my $self = shift;
   $self->{"direction"} = "asc";

   return $self->{"query"};
}

sub desc {
   my $self = shift;
   $self->{"direction"} = "desc";

   return $self->{"query"};
}

sub direction {
   my $self = shift;
   return $self->{"direction"};
}

sub order_by {
   my $self = shift;
   my $ret = "";

   for my $col (@{$self->{"order_by"}}) {
      if($ret) {
         $ret .= ", #$col";
      }
      else {
         $ret = "#$col";
      }
   }

   return $ret;
}

1;
