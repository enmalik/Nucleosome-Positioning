#!/bin/bash

tf=$1;

mkdir -p broadhmm/$tf/normalized;

for state in {1..15}
do
   qsub -S /bin/bash -cwd -o broadhmm/$tf/normalized/$state.log -e broadhmm/$tf/normalized/$state-error.log -N $tf-$state-normalize-job normalize-bash.sh $tf $state
done