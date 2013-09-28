#!/usr/bin/perl
use warnings;

open bedFilesList, "bedfiles-run.txt";

while(<bedFilesList>){
	chomp;
	my $bedfile = "$_";
	print("$bedfile");
	my $bedfilePath = "bedfiles/$bedfile";

	mkdir "$bedfilePath-parts-summit";
	my $writeFileName = "$bedfilePath-parts-summit/$bedfile-modified-summit.txt";
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
	system("bash bedfilesplit.sh $bedfile");
}