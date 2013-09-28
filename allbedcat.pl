#!/usr/bin/perl
use warnings;

my $statsDirectory = "stats/".$ARGV[0]."/bedfileparts-gteq1.5peak-summit";

system("cat $statsDirectory/bed*-stats.txt > $statsDirectory/all-bed-stats.txt");

open allbedstatread, $statsDirectory."/all-bed-stats.txt";
open (bedwrite010, ">".$statsDirectory."/all-bed-stats-010.txt");

while (<allbedstatread>) {
	my @line = split(/\t/,"$_");
	my $distance = $line[0];
	my $intensity = $line[1];

	if ($intensity <= 10) {
		print bedwrite010 "$distance\t$intensity";
	}
}