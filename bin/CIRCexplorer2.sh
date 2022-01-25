#!/usr/bin/bash

TEMP=`getopt -o "" -a -l \
data_dir:,out_dir:,genome_index:,sample:,thread: \
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
        --data_dir|-data_dir) data_dir=$2; shift 2;;
        --out_dir|-out_dir) out_dir=$2; shift 2;;
        --genome_index|-genome_index) genome_index=$2; shift 2;;
        --sample|-sample) sample=$2; shift 2;;
        --thread|-thread) thread=$2; shift 2;;
        --) shift;break;;
        *) echo "Internal error!";exit 1;;
        esac
done

source ~/.bash_profile
export PATH=~/.local/bin:$PATH

genegtf=/projects/compbio/users/byao5/GenomeIndex/GeneAnnotation/$genome_index.genes.gtf
bowtie2Index=/projects/compbio/users/byao5/GenomeIndex/bowtie2_indexes/$genome_index/genome
annotegene=/projects/compbio/users/byao5/DownloadData/fetch_ucsc/${genome_index}_ref.txt
genome=/projects/compbio/users/byao5/DownloadData/fetch_ucsc/$genome_index.fa

newdir=$out_dir/$sample
mkdir $newdir

#requirement
#tophat2 2.1.0

#paired-end mapping
tophat2 -o ${newdir}/tophat_fusion -p $thread --fusion-search --keep-fasta-order --no-coverage-search --library-type fr-unstranded ${bowtie2Index} ${data_dir}/${sample}_1.fq.gz ${data_dir}/${sample}_2.fq.gz

#PYTHONPATH=/projects/compbio/users/byao5/local/lib/python2.7/site-packages
conda activate /projects/compbio/users/byao5/anaconda3/envs/CIRCexplorer2
#parsing
CIRCexplorer2 parse --pe -t TopHat-Fusion ${newdir}/tophat_fusion/accepted_hits.bam -b ${newdir}/back_spliced_junction.bed > ${newdir}/CIRCexplorer2_parse.log

#annoting
CIRCexplorer2 annotate -r ${annotegene} -g ${genome} -b ${newdir}/back_spliced_junction.bed -o ${newdir}/circularRNA_known.txt > ${newdir}/CIRCexplorer2_annotate.log
