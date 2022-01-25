perl 1-Makebed.pl
bash 2-bedtools.sh>IntersectWithA2I.log
grep -v ":" IntersectWithA2I.log|cut -f 4-6 >IntersectWithA2I.bed
bash 3-BedtoolsAlu.sh
