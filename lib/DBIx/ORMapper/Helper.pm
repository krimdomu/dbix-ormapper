#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package DBIx::ORMapper::Helper;

use strict;
use warnings;

require Exporter;
use base qw(Exporter);

use vars qw(@EXPORT);
@EXPORT = qw(SELECT INSERT UPDATE DELETE CREATE ALTER DROP LAST_INSERT_ID);

use DBIx::ORMapper::SQL::Query::SELECT;
use DBIx::ORMapper::SQL::Query::INSERT;
use DBIx::ORMapper::SQL::Query::DELETE;
use DBIx::ORMapper::SQL::Query::UPDATE;
use DBIx::ORMapper::SQL::Query::ALTER;
use DBIx::ORMapper::SQL::Query::CREATE;
use DBIx::ORMapper::SQL::Query::DROP;
use DBIx::ORMapper::SQL::Query::LAST_INSERT_ID;

sub SELECT {
   return DBIx::ORMapper::SQL::Query::SELECT->new;
}

sub INSERT {
   return DBIx::ORMapper::SQL::Query::INSERT->new;
}

sub DELETE {
   return DBIx::ORMapper::SQL::Query::DELETE->new;
}

sub UPDATE {
   return DBIx::ORMapper::SQL::Query::UPDATE->new;
}

sub ALTER {
   return DBIx::ORMapper::SQL::Query::ALTER->new;
}

sub CREATE {
   return DBIx::ORMapper::SQL::Query::CREATE->new;
}

sub DROP {
   return DBIx::ORMapper::SQL::Query::DROP->new;
}

sub LAST_INSERT_ID {
   return DBIx::ORMapper::SQL::Query::LAST_INSERT_ID->new;
}


1;
