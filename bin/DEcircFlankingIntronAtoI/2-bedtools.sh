ls |grep "chr"|while read circ ;

do
echo $circ

bedtools intersect -wo -F 1 -a $circ/UpIntron.bed -b ../../Sailor/A2I.Pval0.05A2Idif0.1.bed
bedtools intersect -wo -F 1 -a $circ/DownIntron.bed -b ../../Sailor/A2I.Pval0.05A2Idif0.1.bed

done




