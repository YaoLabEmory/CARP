open FIG,"<../../../Rawdata/sample_names.txt";
while(<FIG>){
   chomp;
   push(@sample,$_);
}
close FIG;

foreach $sample (@sample){
open FIG,"<$sample.RC";
open OUT,">$sample.RC.bed";
while(<FIG>){
   chomp;
   @_=split(/\s+|:|-/);
   foreach $tmp (@_){
      if($_[2]>$_[1]){
      print OUT "$tmp\t";
      }
      else{
         print "ERROR:\t$sample\t$_\n";
      }
   }
   print OUT "\n";
}
close FIG;
system("bedtools sort -i $sample.RC.bed >$sample.RC.sorted.bed");
}
