use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'DM4P',
   VERSION_FROM => 'lib/DM4P.pm',
   PREREQ_PM => {'Exception::Class' => '0'},
   LICENSE => 'perl'
);

