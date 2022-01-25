ls |grep "chr"|grep -v "log"|while read circ ;

do
echo $circ

cat ../../bin/RBP-CLIP-GeneYeo/RBPlist | while read RBP ;
do
echo $RBP >> $circ.intersect.log

bedtools intersect -u -wa -F 1 -a $circ/UpIntron-hg19.bed -b ../../bin/RBP-CLIP-GeneYeo/$RBP.intersect.bed >>$circ.intersect.log
bedtools intersect -u -wa -F 1 -a $circ/DownIntron-hg19.bed -b ../../bin/RBP-CLIP-GeneYeo/$RBP.intersect.bed >>$circ.intersect.log

done
done




