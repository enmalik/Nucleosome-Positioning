#!/bin/bash

# tally for each state

for state in {1..15}
do	
	echo $state
	cat "stats/run.txt" | while read tf; do
		tally=`wc broadhmm/$tf/$state-intersect.bed | awk {'print $1'}`
		echo -e "$tf\t$tally"
	done > broadhmm/$state-tally.txt
done


# for easier processing later, tally for each factor according to state

cat "stats/run.txt" | while read tf; do
	echo "$tf"
	for state in {1..15}
	do
		tally=`wc broadhmm/$tf/$state-intersect.bed | awk {'print $1'}`
		echo -e "$tally"
	done > broadhmm/$tf/factor-tally.txt
done 