#!/usr/bin/perl
use warnings;
use integer;
use POSIX;

my $statsDirectory = "stats";

open runfile, "$statsDirectory/run.txt";# or die $!;

# open (writefileViolinplotIntensity, ">".$statsDirectory."/violin-intensity.txt");# or die $!;
# open (writefileViolinplotDistance, ">".$statsDirectory."/violin-distance.txt");# or die $!;

open (writefileScatter, ">".$statsDirectory."/scatter-plot-data-normalized.txt");
open (writefileScatterColour, ">".$statsDirectory."/scatter-plot-data-colour-normalized.txt");

#check cluster colour file
my $colourbarFile = 'stats/heatmap-cluster-colours-tallyovermean.txt';
my $clusterColourFlag = 0;
my @clusterColours = ();
if (-e $colourbarFile) {
	print "Cluster colour file exists.\n";
	$clusterColourFlag = 1;
	open (clusterColourFile, $colourbarFile);

	while (<clusterColourFile>) {
		@clusterColours = split(/#/,"$_");
	}
} else {
	print "Cluster colour file doesn't exist.\n";
}

my $counter = 1;

while (<runfile>){
	chomp;
	my $currTf = $_;
	print "$currTf\n";
	# print "$statsDirectory/$currTf/bedfileparts-gteq1.5peak-summit/all-bed-stats-010.txt\n";

	open currTfAllBedStatsFile, "$statsDirectory/$currTf/bedfileparts-gteq1.5peak-summit/all-bed-stats-010.txt";# or die $!;

	open currTfMaxpeakFile, "$statsDirectory/$currTf/bedfileparts-gteq1.5peak-summit/splinemaxpeak.txt";

	my $distance = 0;
	my $intensity = 0;

	while (<currTfAllBedStatsFile>) {
		chomp;
		my @line = split(/\t/,"$_");

		$distance = $line[0];
		$intensity = $line[1];

		# print "$distance\t$intensity\n";

		# print writefileViolinplotDistance "$distance\t";
		# print writefileViolinplotIntensity "$intensity\t";

	}

	while (<currTfMaxpeakFile>) {
		chomp;
		# print "$_\n";
		my @maxPeakLines = split(/\t/,"$_");
		my $violinColour = "";
		my $scatterLabel = "";

		if ($maxPeakLines[1] >= 3) {
			$violinColour = "blue";
			$scatterLabel = $currTf;
		} else {
			$violinColour = "orange";
			$scatterLabel = ".";
		}

		my $scatterNumberLabel = "$counter";
		my $scatterNumberNameLabel = "$counter-$currTf";

		my $pointColourHex = "-";
		if ($clusterColourFlag == 1) {
			$pointColourHex = $clusterColours[$counter];
			# print "$pointColourHex\n";
		}

		# print "$currTf\t$pointColourHex\n";

		print writefileScatter "$_\t$violinColour\t$scatterLabel\t$scatterNumberLabel\t$scatterNumberNameLabel\t$pointColourHex\t$currTf";
		# print writefileScatterColour "#"."$pointColourHex\n";
	}

	# print "$currTf\t$distance\t$intensity\n";

	# print writefileViolinplotDistance "\n";
	# print writefileViolinplotIntensity "\n";
	print writefileScatter "\n";

	$counter++;

}