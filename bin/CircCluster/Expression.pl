@file=("A3SS","A5SS");
foreach $file (@file){
open FIG,"<../$file";
open OUT,">$file.expression";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   @complexity=split(/\//,$_[4]);
   print OUT "$_[0]-$_[1]";
   foreach $sample (@complexity){
      print OUT "\t$sample"
   }
   print OUT "\n";
}
close FIG;
close OUT;
}


