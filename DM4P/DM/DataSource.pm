package DM4P::DM::DataSource;

use strict;
use warnings;

use Want;
use Data::Dumper;

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------

# Function: new
#
#   Creates an new DM4P::DM::DataSource Object.
#
# Returns:
#
#   DM4P::DM::DataSource
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
		if(ref($self)) {
			# ein data object zurueckgeben
			$ret_o = $self->get_data_object();
			if(want(qw'LVALUE ASSIGN')) {
				# wenn als lvalue verwendet, dann die referenz auf data zurueckgeben
				$ret_o = $ret_o->data;
			}
		} else {
			# ein vergleichsobjekt zurueckgeben
			$ret_o = DM4P::DM::Comparable->new(ds => $class, model => $class, key => $attr);
		}

		$ret_o;
	};
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
#    DM4P::DM::Query
sub all {
	my $self = shift;
	return DM4P::DM::Query->new(model => $self->model, @_);
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
	my ($model) = ref($self) =~ m/^.*::(.*?)$/;

	return $model;
}


1;
