#!/bin/bash
TEMP=`getopt -o "" -a -l \
sample_txt:,out_dir: \
-- "$@"`

if [ $? != 0 ]
then
    echo "Terminating....." >&2
    exit 1
fi

eval set -- "$TEMP"

while true
do
    case "$1" in
        --sample_txt|-sample_txt) sample_txt=$2; shift 2;;
        --out_dir|-out_dir) out_dir=$2; shift 2;;
        --) shift;break;;
        *) echo "Internal error!";exit 1;;
        esac
done

#load module
#module load samtools/1.9
#module load bedtools/2.27.0

# Create a unique folder on the local compute drive
if [ -e /bin/mktemp ]; then
    TMPDIR=`/bin/mktemp -d -p /scratch/` || exit
elif [ -e /usr/bin/mktemp ]; then
    TMPDIR=`/usr/bin/mktemp -d –p /scratch/` || exit
else
    echo “Error: Cannot find mktemp to create tmp directory” ||  exit
fi

sorted_bed_dir=${out_dir}/sortedbed

if [[ ! -e $sorted_bed_dir ]]; then
    mkdir $sorted_bed_dir
elif [[ ! -d $sorted_bed_dir ]]; then
    echo "$sorted_bed_dir already" 1>&2
fi

sorted_bam_dir=${out_dir}/sortedbam
if [[ ! -e $sorted_bam_dir ]]; then
    mkdir $sorted_bam_dir
elif [[ ! -d $sorted_bam_dir ]]; then
    echo "$sorted_bam_dir already" 1>&2
fi

echo  "Sample_Name"  "Raw_Reads"	"Mapped_Reads" "Mapped_Ratio"	"Monoconal_Reads" "Monoconal_Ratio"> ${out_dir}/summary.txt

cat ${sample_txt} | while read sample ;
do
#  cp ${out_dir}/${sample}/accepted_hits.bam ${TMPDIR}/
#  samtools sort ${TMPDIR}/accepted_hits.bam > ${TMPDIR}/${sample}.sorted.bam
#  bedtools bamtobed -split -i ${TMPDIR}/${sample}.sorted.bam > ${TMPDIR}/${sample}.bed
#  sort -k 1,1 -k2,2n ${TMPDIR}/${sample}.bed > ${TMPDIR}/${sample}.sorted.bed
#  cp ${TMPDIR}/${sample}.sorted.bed ${sorted_bed_dir}/
#  cp ${TMPDIR}/${sample}.sorted.bam ${sorted_bam_dir}/

  Raw_pair=$(grep "Input" ${out_dir}/${sample}/align_summary.txt | head -n 1| awk -F ':' '{print $2}')
  Raw_Reads=$(($Raw_pair * 2))
  Aligned_pair=$(grep "Aligned pairs" ${out_dir}/${sample}/align_summary.txt | awk -F ':' '{print $2}')
  Discordant_pair=$(grep "discordant" ${out_dir}/${sample}/align_summary.txt | awk -F '(' '{print $1}')
  Mapped_Reads=$((($Aligned_pair - $Discordant_pair) * 2))
  Mapped_Ratio_int_percent=$(($Mapped_Reads * 100/ $Raw_Reads))
  Mapped_Ratio_dec_percent=$((($Mapped_Reads * 10000/ $Raw_Reads) % 100))
  Multiple_Aligned_Reads=$(grep "multiple alignments" ${out_dir}/${sample}/align_summary.txt | tail -n 1 | awk -F ':' '{print $2}' | awk -F '(' '{print $1}')
  Monoclonal_Reads=$(($Mapped_Reads - $Multiple_Aligned_Reads * 2))
  Monoclonal_Ratio_int_percent=$(($Monoclonal_Reads * 100/ $Mapped_Reads))
  Monoclonal_Ratio_dec_percent=$((($Monoclonal_Reads * 10000/ $Mapped_Reads) % 100))

  echo  $sample \
      $Raw_Reads \
      $Mapped_Reads \
      $Mapped_Ratio_int_percent.${Mapped_Ratio_dec_percent}% \
      $Monoclonal_Reads \
      $Monoclonal_Ratio_int_percent.${Monoclonal_Ratio_dec_percent}% \
      >>  ${out_dir}/summary.txt
done
