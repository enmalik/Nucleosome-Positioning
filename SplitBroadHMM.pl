#!/usr/bin/perl
use warnings;
use integer;

$broadhmmPath = "broadhmm/wgEncodeBroadHmmGm12878HMM.bed";

for ($state = 1; $state < 16; $state++) {
print "$state\n";
$writePath = "broadhmm/$state.bed";
open (writeSplitState, ">$writePath");
	open broadhmmFile, $broadhmmPath;
	while (<broadhmmFile>) {
		chomp;
		my @line = split(/\t/,"$_");
		
		# print index($line[3], $state);

		if (index($line[3],"$state"."_") == 0) {
			# print "$line[3]\n";
			print writeSplitState "$_\n";
		}
	}
}