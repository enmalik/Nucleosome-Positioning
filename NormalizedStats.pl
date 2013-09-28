#!/usr/bin/perl

my $runfilePath = "stats/run.txt";
open runfile, "stats/run.txt";

# print index("this is a string", "t");


while(<runfile>) {
	chomp;
	my $factor = $_;
	# print "$factor\n";

	open (writefileSampleMean, ">broadhmm/$factor/normalized/factor-sample-mean.txt");
	open (writefileRealStat, ">broadhmm/$factor/normalized/factor-real-stat.txt");

	for ($state = 1; $state < 16; $state++) {
		# print "$state\n";
		open factorStateFile, "broadhmm/$factor/normalized/$state.txt";

		# print "broadhmm/$factor/normalized/$state.txt\n";
		my $factorStateSampleMean = 0;
		my $factorStateRealStat = 0;

		my $counter = 1;

		while (<factorStateFile>) {
			chomp;
			my $line = $_;
			# print "$line\n";

			if(index($line, "The sample mean") != -1) {
				my @line = split(/\s/,"$_");
				$factorStateSampleMean = $line[5];
				print "FOUND\n";
				# print "@line\n";
				# print "$line[5]\n";
			}

			if(index($line, "The real stat") != -1) {
				my @line = split(/\s/,"$_");
				$factorStateRealStat = $line[5];
				print "FOUND\n";
				# print "@line\n";
				# print "$line[5]\n";
			}
		}
		print "$factorStateSampleMean\n";
		print "$factorStateRealStat\n";

		print writefileSampleMean "$factorStateSampleMean\n";
		print writefileRealStat "$factorStateRealStat\n";
	}
}