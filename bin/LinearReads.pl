$datapath="../../../Rawdata/";

open FIG,"<$datapath/sample_names.txt";
while(<FIG>){
   chomp;
   push(@sample,$_);
}
close FIG;

foreach $sample (@sample){

%RC=();

open FIG,"<../$sample.sam";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   if($_[4]>20){
      $RC{$_[2]}++;
   }
}
close FIG;

open OUT,">$sample.RC";
foreach $circ (sort keys %RC){
   print OUT "$circ\t$RC{$circ}\n";
}
close OUT;

}
