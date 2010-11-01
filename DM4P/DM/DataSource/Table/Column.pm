package DM4P::DM::DataSource::Table::Column;

use strict;
use warnings;

use base qw(DM4P::DM::DataSource::Data);

sub new {
	my $that = shift;
	my $proto = ref($that) || $that;
   	my $self = $proto->SUPER::new(@_);

	bless($self, $proto);

	return $self;
}

1;
