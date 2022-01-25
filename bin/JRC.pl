open FIG,"<../../../Rawdata/sample_names.txt";
while(<FIG>){
   chomp;
   push(@sample,$_);
}
close FIG;

open OUT,">summary.txt";
print OUT "Sample\tCircNumber\tJunctionReadsCount\n";
foreach $sample (@sample){
      $circ=0;
      $JRC=0;
      open FIG,"<$sample.RC";
      while(<FIG>){
         chomp;
         @_=split(/\s+/);
         $circ++;
         $JRC=$JRC+$_[-1]; 
      }
      print OUT "$sample\t$circ\t$JRC\n";
}
