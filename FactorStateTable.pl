#!/usr/bin/perl
use warnings;
# use integer;
use List::Util qw(sum);
use Math::BigFloat;

open runfile, "stats/run.txt";
$writeTablePath = "stats/factor-state-table.txt";
$writeTablePercentPath = "stats/factor-state-percent-table.txt";
open (writeFactorStateTableFile, ">".$writeTablePath);
open (writeFactorStateTablePercentFile, ">".$writeTablePercentPath);

print writeFactorStateTableFile "factor\t1_Active_Promoter\t2_Weak_Promoter\t3_Poised_Promoter\t4_Strong_Enhancer\t5_Strong_Enhancer\t6_Weak_Enhancer\t7_Weak_Enhancer\t8_Insulator\t9_Txn_Transition\t10_Txn_Elongation\t11_Weak_Txn\t12_Repressed\t13_Heterochrom/lo\t14_Repetitive/CNV\t15_Repetitive/CNV\n";
# print writeFactorStateTableFile "state1\tstate2\tstate3\tstate4\tstate5\tstate6\tstate7\tstate8\tstate9\tstate10\tstate11\tstate12\tstate13\tstate14\tstate15\n";

# print writeFactorStateTablePercentFile "factor\tstate1\tstate2\tstate3\tstate4\tstate5\tstate6\tstate7\tstate8\tstate9\tstate10\tstate11\tstate12\tstate13\tstate14\tstate15\n";
print writeFactorStateTablePercentFile "factor\t1_Active_Promoter\t2_Weak_Promoter\t3_Poised_Promoter\t4_Strong_Enhancer\t5_Strong_Enhancer\t6_Weak_Enhancer\t7_Weak_Enhancer\t8_Insulator\t9_Txn_Transition\t10_Txn_Elongation\t11_Weak_Txn\t12_Repressed\t13_Heterochrom/lo\t14_Repetitive/CNV\t15_Repetitive/CNV\n";


my @factorTotals = ();

while (<runfile>) {
	chomp;
	my $factor = $_;
	print "$factor\n";

	my $factorSum = 0;
	
	print writeFactorStateTableFile "$factor\t";
	open tallyfile, "broadhmm/$factor/factor-tally.txt";

	while (<tallyfile>) {
		chomp;
		my $stateTally = $_;
		print writeFactorStateTableFile "$stateTally\t";
		# push(@factorValues, $stateTally);
		$factorSum += $stateTally;
	}

	close tallyfile;
	print writeFactorStateTableFile "\n";
	# $factorSum = sum(@factorValues);

	print writeFactorStateTablePercentFile "$factor\t";
	open tallyfile, "broadhmm/$factor/factor-tally.txt";

	while (<tallyfile>) {
		chomp;
		my $stateTally = $_;
		my $statePercent = $stateTally / $factorSum;
		print ref $stateTally; 

		print "factorsum: $factorSum\n";
		print "$stateTally\n";
		print "$statePercent\n";

		print writeFactorStateTablePercentFile "$statePercent\t";
	}

	close tallyfile;
	print writeFactorStateTablePercentFile "\n";

	# push(@factorTotals, sum(@factorValues));
	
}

# foreach (@factorTotals)
# {
#       print "$_\n";
# }

# print $factorTotals[1];










# for ($state = 1; $state < 16; $state++) {
# 	print "$state\n";
# 	open broadhmmFile, $broadhmmPath;
# 	while (<broadhmmFile>) {
# 		chomp;
# 		my @line = split(/\t/,"$_");
		
# 		# print index($line[3], $state);

# 		if (index($line[3],"$state"."_") == 0) {
# 			# print "$line[3]\n";
# 			print writeSplitState "$_\n";
# 		}
# 	}
# }