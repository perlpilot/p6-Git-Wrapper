Git::Wrapper
============

Hacky way to use git from Perl 6 "inspired" by Perl 5's version of the module of the same name.

## examples

my $git = Git::Wrapper.new( 
    git-executable     => '/path/to/git',
    gitdir              => '/foo/bar',
);

$git.version;       # version of git being used
$git.gitdir;        # path to git repo


