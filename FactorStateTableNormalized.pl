#!/usr/bin/perl
use warnings;
# use integer;
use List::Util qw(sum);
use Math::BigFloat;

open runfile, "stats/run.txt";
$writeTableSampleMeanPath = "stats/factor-state-sample-mean-table.txt";
open (writeFactorStateTableSampleMeanFile, ">".$writeTableSampleMeanPath);

print writeFactorStateTableSampleMeanFile "factor\t1_Active_Promoter\t2_Weak_Promoter\t3_Poised_Promoter\t4_Strong_Enhancer\t5_Strong_Enhancer\t6_Weak_Enhancer\t7_Weak_Enhancer\t8_Insulator\t9_Txn_Transition\t10_Txn_Elongation\t11_Weak_Txn\t12_Repressed\t13_Heterochrom/lo\n";

while (<runfile>) {
	chomp;
	my $factor = $_;
	print writeFactorStateTableSampleMeanFile "$factor\t";

	my @factorTally = ();
	my @factorMean = ();

	open factorTallyFile, "broadhmm/$factor/factor-tally.txt";
	open factorMeanFile, "broadhmm/$factor/normalized/factor-sample-mean.txt";

	while (<factorTallyFile>) {
		chomp;
		# print "$_\n";
		push (@factorTally, $_);
	}

	while (<factorMeanFile>) {
		chomp;
		# print "$_\n";
		push (@factorMean, $_);
	}

	# print $factorMean[0];

	for ($line = 0; $line < 13; $line++) {
		my $tallyOverMean = $factorTally[$line] / $factorMean[$line];
		print writeFactorStateTableSampleMeanFile "$tallyOverMean\t";
	}
	print writeFactorStateTableSampleMeanFile "\n";
}