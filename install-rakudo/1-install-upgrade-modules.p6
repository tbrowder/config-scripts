#!/usr/bin/env perl6

if !@*ARGS {
    say qq:to/HERE/;
    Usage $*PROGRAM-NAME go

    Install or upgrade zef and other modules.
    HERE
    exit;
}

# install zef
if !'./zef'.IO.d {
    say "zef local repo dir not found... cloning it...";
    my $cmd = "git clone https://github.com/ugexe/zef.git";
    my $proc = Proc.new;
    my $res = $proc.shell("$cmd", :out);
    if !$res {
	say "Error when executing '$cmd'";
	my $msg = $proc.out.slurp-rest;
	say "Msg: '$msg'";
	die "FATAL: Could not install...rakudo may be owned by root.";
    }
    my $code = $proc.exitcode;
    say "Exit code: $res";
    if $code {
	say "Error when executing '$cmd'";
	my $msg = $proc.out.slurp-rest;
	say "Msg: '$msg'";
	die "FATAL";
    }

}
else {
    say "NOTE: zef repo found.";
    say "Attempting to install...";
    my $cmd = "cd zef ; perl6 -Ilib bin/zef install --force .";
    my $proc = Proc.new;
    my $res = $proc.shell("$cmd", :out);
    if !$res {
	say "Error when executing '$cmd'";
	my $msg = $proc.out.slurp-rest;
	say "Msg: '$msg'";
	die "FATAL: Could not install...rakudo may be owned by root.";
    }

    my $code = $proc.exitcode;
    if $code  {
	say "Error when executing '$cmd'";
	my $msg = $proc.out.slurp-rest;
	say "Msg: '$msg'";
	die "FATAL: Could not install...rakudo may be owned by root.";
    }
}


#exit;

# get modules
my $modsfil = './modules';
my $proc = Proc.new;
for $modsfil.IO.lines -> $module {
    say "Attemting to install module '$module'...";
    my $cmd = "zef install --force $module";
    my $res = $proc.shell("$cmd", :out);
    if !$res {
	say "Error when executing '$cmd'";
	my $msg = $proc.out.slurp-rest;
	say "Msg: '$msg'";
	die "FATAL: Could not install...rakudo may be owned by root.";
    }

    my $code = $proc.exitcode;
    if $code  {
	say "Error when executing '$cmd'";
	my $msg = $proc.out.slurp-rest;
	say "Msg: '$msg'";
	die "FATAL: Could not install...rakudo may be owned by root.";
    }
}
