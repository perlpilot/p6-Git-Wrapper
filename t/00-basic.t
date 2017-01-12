
use Test;

#Add the local lib folder.
use lib "{$*PROGRAM.dirname}/../lib";

plan 1;

#Attempt to load the module.
use-ok 'Git::Wrapper', "Can load the module";

done-testing;
