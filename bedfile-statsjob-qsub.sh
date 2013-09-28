#!/bin/bash

tf=$1;

mkdir stats/$tf;

for split in `ls -1 bedfiles/$tf-parts-summit/bedfile* | xargs -n 1 basename`
do 
	qsub -S /bin/bash -cwd -o stats/$tf/$split.log -e stats/$tf/$split-error.log -N $tf-$split-job toolbedgraph-bash.sh $tf $split
	#bash toolbedgraph-bash.sh $tf $split
done