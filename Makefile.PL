use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'DBIx::ORMapper',
   VERSION_FROM => 'lib/DBIx/ORMapper.pm',
   PREREQ_PM => {'Exception::Class' => '0'},
   LICENSE => 'perl'
);

