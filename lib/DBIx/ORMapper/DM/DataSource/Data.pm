package DBIx::ORMapper::DM::DataSource::Data;

use strict;
use warnings;
use mro;

use overload 
   '+' =>  sub { shift->add(@_); },
   '-' =>  sub { shift->sub(@_); },
   '>' =>  sub { shift->gt(@_); },
   '<' =>  sub { shift->lt(@_); },
   '==' => sub { shift->int_eq(@_); },
   'eq' => sub { shift->eq(@_); },
   '""' => sub { shift->data(@_); };

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------

# Function: new
#
#   Creates an new DBIx::ORMapper::DM::Data Object.
#
# Returns:
#
#   DBIx::ORMapper::DM::Data
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   return $self;
}


# ------------------------------------------------------------------------------
# Group: Public
# ------------------------------------------------------------------------------

# Function: to_s
#
#   Returns the data as string
sub to_s {
   my $self = shift;
   return "" . $self->data;
}

# Function: to_i
#
#     Returns the data as integer
sub to_i {
   my $self = shift;
   return int($self->data);
}

# Function: to_l
#
#    Returns the data as long
sub to_l {
   my $self = shift;
   return $self->data;
}

# Function: to_f 
#
#    Returns the data as float
sub to_f {
   my $self = shift;
   return $self->data;
}

# Function: data
#
#    Returns the data as is.
sub data {
   my $self = shift;
   $self->{'data'};
}

# ------------------------------------------------------------------------------
# Group: Overload
# ------------------------------------------------------------------------------

# Function: add
# 
#    Add two DBIx::ORMapper::DM::Data Objects together.
sub add {
   my $class = shift;
   my($r, $l) = @_;
   if($class->_get_super_class($l) eq "DBIx::ORMapper::DM::Data") {
      return $r->data + $l->data;
   } else {
      return $r->data + $l;
   }
}

# Function: sub
#
#    Subtract one Object from the other.
sub sub {
   my $class = shift;
   my($r, $l) = @_;
   if($class->_get_super_class($l) eq "DBIx::ORMapper::DM::Data") {
      return $r->data - $l->data;
   } else {
      return $r->data - $l;
   }
}

# Function: gt
# 
#    greater than comparison
sub gt {
   my $class = shift;
   my($r, $l) = @_;
   if($class->_get_super_class($l) eq "DBIx::ORMapper::DM::Data") {
      return $r->data > $l->data;
   } else {
      return $r->data > $l;
   }
}

# Function: lt
#
#    lower than comparison
sub lt {
   my $class = shift;
   my($r, $l) = @_;
   if($class->_get_super_class($l) eq "DBIx::ORMapper::DM::Data") {
      return $r->data < $l->data;
   } else {
      return $r->data < $l;
   }
}

# Function: eq
#
#    equal comparison
sub eq {
   my $class = shift;
   my($r, $l) = @_;
   if($class->_get_super_class($l) eq "DBIx::ORMapper::DM::Data") {
      return $r->data eq $l->data;
   } else {
      return $r->data eq $l;
   }
}

# Function: int_eq
#
#    equal comparison
sub int_eq {
   my $class = shift;
   my($r, $l) = @_;
   if($class->_get_super_class($l) eq "DBIx::ORMapper::DM::Data") {
      return $r->data == $l->data;
   } else {
      return $r->data == $l;
   }
}

# ------------------------------------------------------------------------------
# Group: Private
# ------------------------------------------------------------------------------

sub _get_super_class {
   my $self = shift;
   my $o = shift;

   my @linear_isa = mro::get_linear_isa($o);
   return $linear_isa[-1];
}

1;
