Git::Wrapper
============

Hacky way to use git from Perl 6 "inspired" by Perl 5's version of the module of the same name.

## SYNOPSIS

    my $git = Git::Wrapper.new( 
        git-executable     => '/path/to/git',
        gitdir              => '/foo/bar',
    );

    $git.version;       # version of git being used
    $git.gitdir;        # path to git repo

## example

    #!/usr/bin/env perl6

    use Git::Wrapper;

    my $git = Git::Wrapper.new( gitdir => "/path/to/existing/dir" );
    $git.clone("https://github.com/rakudo/rakudo.git");
    my @log = $git.log( date => 'iso8601' );

    for @log -> $l {
        my $d = $l.date;
        $d.=subst( ' ', 'T', :n(1)).=subst( ' ', '');   # make it so DateTime can parse the date
        my $dt = DateTime.new($d);                      # just 'cuz
        say "{$l.author} $dt {$l.summary}";
    }
