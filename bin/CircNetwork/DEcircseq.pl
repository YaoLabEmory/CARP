open FIG,"<../../Rawdata/sample_names_AR.txt";
while(<FIG>){
   chomp;
   push(@sample,$_);
}
close FIG;
open FIG,"<../../Rawdata/condition";
while(<FIG>){
   chomp;
   push(@condition,$_);
}
close FIG;

for($i=0;$i<@sample;$i++){
   $condition{$sample[$i]}=$condition[$i];
}

foreach $sample (@sample){
   open FIG,"<../../MergeCirc/AS-BSJ2/$sample/bed/CircSeq/circseq.tab";
   while(<FIG>){
      chomp;
      @_=split(/\t/);
      $condition=$condition{$sample};
      $seq{$condition}{$_[0]}=$_[1];
   }
   close FIG;
}

open FIG,"<../DEup.confident.xls";
open OUT,">DEup/DEup";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   print OUT "$_[-3]\t9606\t$seq{case}{$_[-3]}\n";   
}
close FIG;
close OUT;

open FIG,"<../DEdown.confident.xls";
open OUT,">DEdown/DEdown";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   print OUT "$_[-3]\t9606\t$seq{control}{$_[-3]}\n";
}
close FIG;
close OUT;

