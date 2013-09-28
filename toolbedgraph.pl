#!/usr/bin/perl
use POSIX;
#use Statistics::R;
use warnings;
use File::Path qw(make_path remove_tree);

my $tf = $ARGV[0];
my $bedName   = $ARGV[1];

my $bedDirectory = "bedfiles/$tf-parts-summit/";
my $statsDirectory = "stats/$tf/bedfileparts-gteq1.5peak-summit/";
make_path $statsDirectory;
my $wigDirectory = "wigfiles/wgEncodeSydhNsomeGm12878Sig.wig-parts/";
(my $bedNameWithoutExt = $bedName) =~ s/\.[^.]+$//;
my $statsName = $bedNameWithoutExt."-stats.txt";

print "bedName: $bedName\t statsName: $statsName\n";

open bedfile, $bedDirectory.$bedName;
open (writefile, ">".$statsDirectory.$statsName);

my $bedCount = 0;
my $peakCount = 0;
my $plusMinusRange = 500;
my $peakThreshold = 1.5;
# my $R = Statistics::R->new();
# $R->startR;

while (<bedfile>){
	$bedCount++;
	print "\nBEDCOUNT: $bedCount\n";
	chomp;
	my @line = split(/\t/,"$_");

	my $chr = $line[0];
	my $location = $line[3];
	my $locationFlag = substr($location, 0, -4);

	# $lastDigit = substr($location, -1);
	# $roundUp = (10 - $lastDigit) + 1;

	my $wigRangeBegin = ($location - $plusMinusRange);# + $roundUp;
   	my $wigRangeEnd = ($location + $plusMinusRange);# + $roundUp;

    # print "$line[0]\n";
    # print "$line[3]\n";

    #print "lastdigit \t $lastDigit\t roundUp \t $roundUp\n";
    print "$chr\t$location\n";
    print "$wigRangeBegin\t$wigRangeEnd\n";
    
    open readwigfile, $wigDirectory."$line[0].txt";

    my @wigArrayLocations = ();
    my @wigArrayPeaks = ();
    # my $middleIndex = 0;
    # my $loopTally = 0;

    # # in case the high peak is rather small, at least there will be a peak
    # my $guaranteePeak = 0;

    print "location flag: $locationFlag\n";

    while (<readwigfile>){
    	chomp;
    	if ($_ =~ m/chr.*\t$locationFlag....\t.*$/) {
    		my @wigLines = split(/\t/,"$_");
	    	
    		#print "IN IN IN\n";

	    	#@wigLines = $_;
			# print "@wigLines\n";
	    	if ((($wigLines[1] + $wigLines[2])/2) >= $wigRangeBegin && (($wigLines[1] + $wigLines[2])/2) <= $wigRangeEnd){
	    		#print "IN\n";
	    		push(@wigArrayLocations, ($wigLines[1]+$wigLines[2])/2);
	    		push(@wigArrayPeaks, $wigLines[3]);

	    		# if ($wigLines[3] > $guaranteePeak) {
	    		# 	$guaranteePeak = $wigLines[3];
	    		# }


	    		# if (@wigLines[0] == $location){
	    		# 	$middleIndex = $loopTally;
	    		# }

	    		# $loopTally++;
	    		#print "@wigArray";
	    	} elsif (scalar(@wigArrayLocations) > 1) {
	    		last;
	    	}
    	}
    	#print "$wigRangeBegin     $wigRangeEnd";
    	#print "$_\n";
    }
    close(readwigfile);

    # -------- this used to show

 	# print "middle index: \t $middleIndex\n";

	# #print "@wigArrayLocations\n";
	# print "@wigArrayPeaks\n";
	# print "size: " . scalar(@wigArrayPeaks) . "\n";

	# ------- end show

	my $wigArrayIndices = scalar(@wigArrayPeaks);

    # -------- this used to show

	# for ($i=0; $i<$wigArrayIndices; $i++){
	# 	print "$wigArrayLocations[$i]\t$wigArrayPeaks[$i]\n";
	# }

	# ------- end show

	# print scalar(@wigArrayLocations);
	# print scalar(@wigArrayPeaks);


	# filter out sequential duplicate values
	my @orig_index = 0;
	my @deduped = $wigArrayPeaks[0];
	for my $index ( 1..$#wigArrayPeaks ) {
	    if ( $wigArrayPeaks[$index] != $wigArrayPeaks[$index-1] ) {
	        push @deduped, $wigArrayPeaks[$index];
	        push @orig_index, $index;
	    }
	}

	# print "@wigArrayLocations\n";

	my @maxima = ();
	for my $index ( 0..$#deduped ) {
		#my peakThreshold = 0; # figure out what the threshold should be
		#print "ADDING TO MAXIMA\n";
	    if ($deduped[$index] > $deduped[$index-1] && $deduped[$index] > $deduped[$index+1] &&  $deduped[$index] >= $peakThreshold) { #make variable for peak threshold
	        push @maxima, $orig_index[$index];
	    }
	}

	# if ($wigArrayPeaks[0] > $wigArrayPeaks[1]){
	# 	unshift(@maxima,0);
	# }

	# if ($wigArrayPeaks[-1] > $wigArrayPeaks[-2]){
	# 	push(@maxima,-1);
	# }

	print "********* MAXIMA INDICES *********\n";

	foreach (@maxima) {
		#print "$_\n";
		print "$wigArrayLocations[$_]\t$wigArrayPeaks[$_]\n";
	}

	my $minIndex = 0;
	my $minDistance = abs($location - $wigArrayLocations[0]);
	#print "wigarraylocation:\t$wigArrayLocations[0]\tbefore maxima loop:\t$minDistance\n";
	my $minDistancePeak = 0;

	print "@maxima\n";

	foreach (@maxima) {
		if (abs($location - $wigArrayLocations[$_]) < $minDistance) {
			$minIndex = $_;
			$minDistance = abs($location - $wigArrayLocations[$_]);
			#print "in maxima loop:\t$minDistance\n";
			$minDistancePeak = $wigArrayPeaks[$_];
		}
	}

	if ($minDistance == $location) {
		$minDistance = $plusMinusRange;
	}

	print "minIndex: $minIndex\n";
	print "minDistance: $minDistance\n";
	print "minDistancePeak: $minDistancePeak\n";

	if ($minDistancePeak > 0) {
		print writefile "$minDistance\t$minDistancePeak\n";
		$peakCount++;			
	}
}
close(bedfile);

my $nonPeakCount = $bedCount-$peakCount;

open statfile, ">".$statsDirectory."overview-$statsName.txt";
print statfile "File:\t$statsName\n";
print statfile "Total ranges:\t$bedCount\n";
print statfile "Total peaks:\t$peakCount\t".(($peakCount/$bedCount)*100)."%\n";
print statfile "Total non-peaks:\t".($bedCount-$peakCount)."\t".((($nonPeakCount)/$bedCount)*100)."%\n";
close(statfile);

