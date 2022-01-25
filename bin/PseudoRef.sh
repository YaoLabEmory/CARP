#!/usr/bin/bash
cd MergeCirc/circlist
perl ../../bin/circlist.pl
perl ../../bin/scorecirc.pl
perl ../../bin/mkjuncref-score2.pl
perl ../../bin/mkjuncref-score01.pl
perl ../../bin/linear_lastexon.pl
cat score01.juncref.fa score2.juncref.fa >juncref.fa
bowtie2-build juncref.fa junc
cd ../../
