#!/usr/bin/perl
use integer;
use warnings;


my $tf = $ARGV[0];
my $bedfile = "$tf";
my $bedfilePath = "bedfiles/$bedfile";

mkdir "$bedfilePath-parts-summit";
my $writeFileName = "bedfiles/$bedfile-parts-summit/$bedfile-modified-summit.txt";
open openfile, $bedfilePath;

open (writefile, ">$writeFileName");

while(<openfile>){
	chomp;
	my $line = "$_\n";
	my @entries = split("\t");
	my $middle = $entries[1] + $entries[9] - 1;
	#print "$writeFileName\n";
	print writefile "$entries[0]\t$entries[1]\t$entries[2]\t$middle\n";
}

system("pwd");
system("bash bedfilesplit.sh $tf");