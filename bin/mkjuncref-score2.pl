open FIG,"<../../bin/config";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   $config{$_[0]}=$_[1];
}
close FIG;

$gtf=$config{"gtf"};
$circfile="circlist.bed.gene";
$genome=$config{"genome"};

open FIG,"<$gtf";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   $_[3]--;
   if($_[2] eq "exon"){
      $_[-1]=~s/"//g;
      @info=split(/\;/,$_[-1]);
      @tran=split(/\s+/,$info[-2]);
      $tran=$tran[-1];
      push(@{$start{$tran}},$_[3]);
      push(@{$end{$tran}},$_[4]);
   }
   else{;}
}
close FIG;

open FIG,"<$circfile";
open OUT,">score2.circ.bed";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   if($_[-2]==2){
      @start= @{$start{$_[-3]}};
      @end= @{$end{$_[-3]}};
      for($i=0;$i<@start;$i++){
         if($end[$i]<$_[1]||$start[$i]>$_[2]){;}
         else{
            print OUT "$_[0]\t$start[$i]\t$end[$i]\t$_[0]:$_[1]-$_[2]\n";
         }
      }
   }
}
close FIG;
close OUT;

system("bedtools getfasta -tab -fi $genome -bed score2.circ.bed -fo score2.circ.bed.seq.tab");

open FIG,"<score2.circ.bed.seq.tab";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   $seq{$_[0]}=$_[1];
}
close FIG;

open FIG,"<score2.circ.bed";
open OUT,">score2.juncref.fa";
open FA,">score2.circ.fa";

while(<FIG>){
   chomp;
   @_=split(/\s+/);
   $exon="$_[0]:$_[1]-$_[2]";
   if($_[-1] eq $circ){
      $circseq{$circ}=$circseq{$circ}."$seq{$exon}";
   }
   else{
      $juncdown=substr($circseq{$circ},0,149);
      $juncup=substr($circseq{$circ},length($circseq{$circ})-149,);
      $juncref="$juncup"."$juncdown";
      if($circ){
         print OUT ">$circ\n$juncref\n";
         print FA ">$circ\n$circseq{$circ}\n";
      }
      $circ=$_[-1];
      $circseq{$circ}=$seq{$exon};
   }
}
close FIG;
close OUT;


#system("bowtie2-build score2.juncref.fa score2junc");
system("rm score2.circ.bed.seq.tab");
system("rm score2.circ.bed");
system("rm score2.circ.fa");
#system("rm score2.juncref.fa");

