tf=$1;

bedfileDir="bedfiles/$tf-parts-summit";

echo $bedfileDir;

split -l 4000 $bedfileDir/$tf-modified-summit.txt $bedfileDir/bedfile;