
use Git::Log::Parser;

my sub find-git {

    my $gitdir = qx/which git/;
    $gitdir.=chomp;
    die "No git executable found or specified" unless $gitdir;
    return $gitdir;
}

class Git::Wrapper {
    has $.gitdir = !!! 'gitdir required';
    has $.git-executable = find-git;              # which git
    
    method run($subcommand) {
        my $old-dir = $*CWD;
        chdir($.gitdir);
        my $git-cmd = "$.git-executable $subcommand";
        my $p = open $git-cmd, :p or die;
        my @out = $p.slurp;
        chdir($old-dir);
        return @out;
    }

    method version() {
        return self.run('version');
    }

    method log() {
        my @output = self.run('log');
        my $log-parser = Git::Log::Parser.parse(@output.join, :actions(Git::Log::Actions.new));
        return $log-parser.made;
    }

    method init() {
        return self.run('init');
    }
}

