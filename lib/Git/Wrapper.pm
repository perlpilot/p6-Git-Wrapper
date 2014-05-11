
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
        my $optstr = join " ", map -> $k,$v { $v eqv Bool::True ??  "-$k" !! "--$k='$v'" }, %named.kv;
        @positionals.push(".") if $subcommand eq 'clone' && +@positionals == 1;
        my $git-cmd = "$.git-executable $subcommand $optstr @positionals[] 2>/dev/null";
        my $p = open $git-cmd, :p or die;
        my @out = $p.slurp;
        chdir($old-dir);
        return @out;
    }

    method version() {
        return self.run('version');
    }

    method log(*@p, *%n) {
        %n<date> = "iso8601";
        my @output = self.run('log', |@p, |%n);
        my $log-parser = Git::Log::Parser.parse(@output.join, :actions(Git::Log::Actions.new));
        return $log-parser.made.list;
    }

    method init(*@p, *%n) { return self.run('init', |@p, |%n); }
    method clone(*@p, *%n) { return self.run('clone', |@p, |%n); }
    method branch(*@p, *%n) { return self.run('branch', |@p, |%n); }
    method checkout(*@p,*%n) { return self.run('checkout',|@p, |%n); }
    method add(*@p,*%n) { return self.run('add',|@p, |%n); }
    method pull(*@p,*%n) { return self.run('pull',|@p, |%n); }
    method reset(*@p,*%n) { return self.run('reset',|@p, |%n); }
    method rebase(*@p,*%n) { return self.run('rebase',|@p, |%n); }
    method push(*@p,*%n) { return self.run('push',|@p, |%n); }
    method fetch(*@p,*%n) { return self.run('fetch',|@p, |%n); }
    method commit(*@p,*%n) { return self.run('commit',|@p, |%n); }
    method show(*@p,*%n) { return self.run('show',|@p, |%n); }
    method status(*@p,*%n) { return self.run('status',|@p, |%n); }
    method diff(*@p,*%n) { return self.run('diff',|@p, |%n); }
    method grep(*@p,*%n) { return self.run('grep',|@p, |%n); }
    method merge(*@p,*%n) { return self.run('merge',|@p, |%n); }
    method mv(*@p,*%n) { return self.run('mv',|@p, |%n); }
    method rm(*@p,*%n) { return self.run('rm',|@p, |%n); }
    method tag(*@p,*%n) { return self.run('tag',|@p, |%n); }

}

