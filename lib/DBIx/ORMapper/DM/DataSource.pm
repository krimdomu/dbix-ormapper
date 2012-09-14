package DBIx::ORMapper::DM::DataSource;

use strict;
use warnings;

use Data::Dumper;
use Want;
use DBIx::ORMapper::Exception::DataTypeNotKnown;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------

use vars qw(@db_fields);

# Function: new
#
#   Creates an new DBIx::ORMapper::DM::DataSource Object.
#
# Returns:
#
#   DBIx::ORMapper::DM::DataSource
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = {};

   bless($self, $proto);

   my %fields = ref($self)->get_fields_info();

   #$self->{'__data'} = { @_ };
   my $values = { @_ };
   for my $key (keys %{ $values }) {
      $self->get_data($key, $fields{$key}, $values->{$key});
   }

   return $self;
}

# ------------------------------------------------------------------------------
# Group: Public
# ------------------------------------------------------------------------------

# Function: attr
#
#    Add some attributes to the Model.
#    This Method creates the needed methods so we don't need to use 
#    AUTOLOAD here.
#
# Parameters:
#
#    string - attribute name
#    string - attribute type
sub attr {
   my ($class, $attr, $type) = @_;
   no strict 'refs';

   *{"${class}::$attr"} = sub : lvalue {
      my ($self, @params) = @_;
      my $ret_o;
      if(want(qw{LVALUE ASSIGN})) {
         $self->{'__data'}->{$attr};
      } else {
         if(ref($self)) {
            # ein data object zurueckgeben
            $ret_o = $self->get_data($attr, $type);
         } else {
            # ein vergleichsobjekt zurueckgeben
            $ret_o = DBIx::ORMapper::DM::Comparable->new(ds => $class, model => $class, key => $attr);
         }

         $ret_o;
      }
   };

   my $arr = $class . "::tbl_fields";
   push(@$arr, {$attr => $type});
}

# ------------------------------------------------------------------------------
# Group: Query Methods
# ------------------------------------------------------------------------------

# Function: all
#
#    Fetch Records.
#
# Parameters:
#
#    List - Comparable Objects
#
# Returns:
#
#    DBIx::ORMapper::DM::Query
sub all {
   my $self = shift;
   return DBIx::ORMapper::DM::Query->new(ds => $self, model => $self->model, @_);
}

# Function: model
#
#    Returns the Model name.
#
# Returns:
#
#    String - Modelname
sub model {
   my $self = shift;
   my $model;
   if(ref($model)) {
      ($model) = ref($self) =~ m/^.*::(.*?)$/;
   } else {
      no strict 'refs';
      my $var = $self . "::db_table";
      $model = $$var;
   }

   return $model;
}

sub get_select {
   my $self = shift;

   if(ref($self) eq "DBIx::ORMapper::DM::DataSource") {
      # todo: throw exception, must be overwritten
      die("must be overwritten");
   }
}

sub get_fields_info {
   my $class = shift;
   my $arr = $class . "::tbl_fields";

   no strict 'refs';
   return map { (keys %$_, values %$_) } @$arr;
}

sub get_fields {
   my $class = shift;
   my $arr = $class . "::tbl_fields";

   no strict 'refs';
   return map { [ keys %$_ ] } @$arr;
}

sub get_data {
   my $self = shift;
   my $key = shift;
   my $type = shift;
   my $value = shift;

   unless($key) {
      return $self->{'__data'};
   }

   my $data_type = $self->get_data_source()->class_type();
   my $field_class = "DBIx::ORMapper::SQL::Dialects::${data_type}::Table::Column::Type::$type";
   eval "use $field_class;";
   if($@) {
      DBIx::ORMapper::Exception::DataTypeNotKnown->throw(error => 'Data-Type ' . $type . ' not known to the underlying adapter. (' . $@ . ')');
   }

   my $data = $value;
   $data ||= $self->{'__data'}->{$key};

   tie $self->{'__data'}->{$key}, $field_class, $data;

   return $data;
}

sub set_data_source {
   my $class = shift;

   no strict 'refs';
   my $var = "${class}::data_source";
   $$var = shift;
   my $tmp = $$var; # suppress warnings
}

sub get_data_source {
   my $class = shift;
   if(ref($class)) { $class = ref($class); }

   no strict 'refs';
   my $var = "${class}::data_source";
   $$var;
}

sub find {
   my $self = shift;
   my $find = shift;

   die("Must be overwritten by implementation");
}

sub save {
   my $self = shift;

   die("Must be overwritten by implementation");
}



1;
