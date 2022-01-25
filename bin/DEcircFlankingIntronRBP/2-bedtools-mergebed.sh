ls |grep "chr"|while read circ ;

do
echo $circ

#rm $circ.log

#cat /projects/compbio/users/byao5/DownloadData/RBP-CLIP-GeneYeo/RBPlist | while read RBP ;
#do
RBP="KHSRP"
echo $RBP >> $circ.log

bedtools intersect -u -wa -F 1 -a $circ/UpIntron-hg19.bed -b /projects/compbio/users/byao5/DownloadData/RBP-CLIP-GeneYeo/$RBP.merge.bed >>$circ.log
bedtools intersect -u -wa -F 1 -a $circ/DownIntron-hg19.bed -b /projects/compbio/users/byao5/DownloadData/RBP-CLIP-GeneYeo/$RBP.merge.bed >>$circ.log

done
#done




