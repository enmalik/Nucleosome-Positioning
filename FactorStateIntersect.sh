cat "stats/run.txt" | while read tf; do 
    mkdir broadhmm/$tf
    echo $tf
    for state in {1..15}
	do
	    bedtools intersect -a bedfiles/$tf -b broadhmm/$state.bed > broadhmm/$tf/$state-intersect.bed
	done
done