open FIG,"<A2I.Pval0.05A2Idif0.1.xls";
open OUT,">A2I.Pval0.05A2Idif0.1.bed";
while(<FIG>){
   chomp;
   if(/HOG/){next;}
   @_=split(/\s+|-/);
   $end=$_[1]+1;
   print OUT "$_[0]\t$_[1]\t$end\n";
}
