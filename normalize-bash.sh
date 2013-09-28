#!/bin/bash

tf=$1;
state=$2;

rm broadhmm/$tf/normalized/$state.txt;
python normalize/block_bootstrap.py -1 bedfiles/$tf -2 broadhmm/$state.bed -d normalize/wgEncodeUwDnaseGm12878HotspotsRep1.broadPeak -r 0.041 -n 1000 -v -B -o broadhmm/$tf/normalized/$state.txt
#-1 and -2 switched from before