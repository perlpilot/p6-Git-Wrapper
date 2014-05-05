
use Git::Log::Parser;

my sub find-git {
    my $gitdir = qx/which git/;
    $gitdir.=chomp;
    die "No git executable found" unless $gitdir;
    return $gitdir;
}

class Git::Wrapper {
    has $.gitdir = !!! 'gitdir required';
    has $.git-executable = find-git;              # which git
    
    method run($subcommand, *@positionals, *%named) {
        my $old-dir = $*CWD;
        chdir($.gitdir);
        my $optstr = '';
        for %named.kv -> $k, $v {
            $optstr ~= $v eqv Bool::True ??  "-$k" !! "--$k='$v'";
        }
        @positionals.push(".") if $subcommand eq 'clone' && +@positionals == 1;
        my $git-cmd = "$.git-executable $subcommand $optstr @positionals[]";
        my $p = open $git-cmd, :p or die;
        my @out = $p.slurp;
        chdir($old-dir);
        return @out;
    }

    method version() {
        return self.run('version');
    }

    method log(*%_) {
        my @output = self.run('log');
        my $log-parser = Git::Log::Parser.parse(@output.join, :actions(Git::Log::Actions.new));
        return $log-parser.made;
    }

    method init() {
        return self.run('init');
    }

    method clone($url, *%_) {
        return self.run('clone', $url);
    }

    method branch($branchname?, *%_) {
        return self.run('branch', $branchname, |%_);
    }

    method checkout($thingy, *%_) {
        return self.run('checkout', $thingy, |%_);
    }
}

