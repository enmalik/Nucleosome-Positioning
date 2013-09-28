#!/usr/bin/perl
use warnings;

my $wigfile   = $ARGV[0];

open FILE, "wigfiles/$wigfile";
my $dirname = "wigfiles/$wigfile-parts";
system("rm -f $dirname/*");
mkdir $dirname;

while (<FILE>){
	chomp;
	$line = "$_\n";
	if ($line =~ /(^.*section )(chr.*)(:.*$)/) {
		$curfile = "$dirname/$2.txt";
		print "$curfile\n";
		close(writefile);
		open (writefile, ">>$curfile");
		print "$1\n";
	} elsif ($curfile) {
	 	print writefile $line;
	}
}
close (writefile);