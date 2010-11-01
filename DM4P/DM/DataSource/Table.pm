package DM4P::DM::DataSource::Table;

use strict;
use warnings;

use base qw(DM4P::DM::DataSource);

# ------------------------------------------------------------------------------
# Group: Constructor
# ------------------------------------------------------------------------------

# Function: new
#
#   Creates an new DM4P::DM::DataSource::Table Object.
#
# Returns:
#
#   DM4P::DM::DataSource::Table
sub new {
	my $that = shift;
	my $proto = ref($that) || $that;
   	my $self = $proto->SUPER::new(@_);

	bless($self, $proto);

	return $self;
}

1;
