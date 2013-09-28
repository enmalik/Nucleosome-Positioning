#!/usr/bin/perl
use warnings;

open statsList, "stats/run.txt";

while (<statsList>) {
	chomp;
	my $tf = "$_";
	print "$tf\n";
	system("Rscript bedfileplot.r $tf");
}