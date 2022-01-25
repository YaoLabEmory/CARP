#!/usr/bin/bash

TEMP=`getopt -o "" -a -l \
data_dir:,out_dir:,genome_index:,sample: \
-- "$@"`

if [ $? != 0 ]
then
    echo "Terminating due to unrecognized input arguments! Please specify input values for correct arguments!" >&2
    exit 1
fi

eval set -- "$TEMP"

while true
do
    case "$1" in
        --data_dir|-data_dir) input=$2; shift 2;;
        --out_dir|-out_dir) output=$2; shift 2;;
        --genome_index|-genome_index) genome_index=$2; shift 2;;
        --sample|-sample) sample=$2; shift 2;;
        --) shift;break;;
        *) echo "Internal error!";exit 1;;
        esac
done

source ~/.bash_profile

#PYTHONPATH=/projects/compbio/users/byao5/local/lib/python2.7/site-packages
conda activate /projects/compbio/users/byao5/anaconda3/envs/findcirc
bowtie2Index=/projects/compbio/users/byao5/GenomeIndex/bowtie2_indexes/${genome_index}/genome
genome=/projects/compbio/users/byao5/GenomeIndex/bowtie2_indexes/${genome_index}/genome.fa

cd $output

bowtie2 -p 24 --very-sensitive --score-min=C,-15,0 --reorder --mm -1 ${input}/${sample}_1.fq.gz -2 ${input}/${sample}_2.fq.gz -x $bowtie2Index 2> ${sample}.log >${sample}_map.sam
samtools view -@ 24 -hbuS ${sample}_map.sam >${sample}_map.bam
samtools sort -@ 24 ${sample}_map.bam -o ${sample}_map.sorted

samtools view -@ 24 -hf 4 ${sample}_map.sorted | samtools view -@ 24 -Sb >${sample}_upmap.bam
unmapped2anchors.py ${sample}_upmap.bam >${sample}_unmap.fastq
gzip ${sample}_unmap.fastq

mkdir ${sample}
bowtie2 -p 24 --score-min=C,-15,0 --reorder --mm -q -U ${sample}_unmap.fastq.gz -x $bowtie2Index |find_circ.py --genome=${genome} --prefix=ce6_test_ --name=${sample} --stats=${sample}/stats.txt --reads=${sample}/spliced_reads.fa > ${sample}/splice_sites.bed
grep CIRCULAR ${sample}/splice_sites.bed |awk '$5>=2'|grep UNAMBIGUOUS_BP|grep ANCHOR_UNIQUE| maxlength.py 100000 >${sample}/circ_candidates.bed
