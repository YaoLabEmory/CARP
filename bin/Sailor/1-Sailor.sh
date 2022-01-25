CARP_home="/projects/compbio/users/byao5/RNAseq/CARP"
home="/home/byao5"
genome="/projects/compbio/users/byao5/GenomeIndex/iGenome/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta"


export SINGULARITY_BIND="$CARP_home/Sailor:$home,$CARP_home/RNAseq/sortedbam:$CARP_home/RNAseq/sortedbam"
fastq_data_dir=../Rawdata
cat $fastq_data_dir/sample_names_RM.txt | while read sample ;
do

echo "\
#!/usr/bin/env sailor-1.0.4
input_bam:
  class: File
  path: /projects/compbio/users/byao5/RNAseq/CARP/RNAseq/sortedbam/HOGD0_2.sorted.bam
reference:
  class: File
  path: /projects/compbio/users/byao5/GenomeIndex/iGenome/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta/genome.fa
known_snp:
  class: File
  path: /projects/compbio/users/byao5/RNAseq/CARP/RNAseq/sortedbam/known_SNPs.bed
single_end: false
" >$sample.yaml

echo "#!/usr/bin/bash" >${sample}.sh
echo "source ~/.bash_profile" >>${sample}.sh
echo "module purge" >>${sample}.sh
echo "module load singularity" >>${sample}.sh
echo "export SINGULARITY_BIND=$genome:$genome,$CARP_home/Sailor:$home,$CARP_home/RNAseq/sortedbam:$CARP_home/RNAseq/sortedbam" >>${sample}.sh
echo "sailor-1.0.4 $sample.yaml" >>${sample}.sh
sbatch --partition=week-long-cpu --ntasks=8 -J $sample -o $sample.out -e $sample.err \
	${sample}.sh
done
