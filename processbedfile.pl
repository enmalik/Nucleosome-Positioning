#!/usr/bin/perl
use integer;
use warnings;


#system("rm -rf $dirname");

my $bedfile   = $ARGV[0];

my $bedfilePath = "testbedfiles/$bedfile";
my $writeFileName = "testbedfiles/$bedfile-modified.txt";
open openfile, $bedfilePath;
#system("rm -rf $writeFileName");
#mkdir $dirname;

open (writefile, ">$writeFileName");

while(<openfile>){
	chomp;
	my $line = "$_\n";
	my @entries = split("\t");
	my $middle = ($entries[1] + $entries[2])/2;
	#print "$writeFileName\n";
	print writefile "$entries[0]\t$entries[1]\t$entries[2]\t$middle\n";
}