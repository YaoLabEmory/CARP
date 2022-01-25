open FIG,"<../../../Rawdata/sample_names.txt";
while(<FIG>){
   chomp;
   push(@sample,$_);
}
close FIG;

foreach $sample (@sample){
   open FIG,"<$sample.RC";
   while(<FIG>){
      chomp;
      @_=split(/\s+/);
      $RC{$sample}{$_[0]}=$_[1];
      $circ{$_[0]}++;
   }
   close FIG;
}

open OUT,">RC";
open BED,">circ.bed";
foreach $sample (@sample){
   print OUT "\t$sample";
}
print OUT "\n";

foreach $circ (keys %circ){
   print OUT "$circ";
   @circ=split(/:|-/,$circ);
   print BED "$circ[0]\t$circ[1]\t$circ[2]\n";
   foreach $sample (@sample){
      if($RC{$sample}{$circ}){;}
      else{
         $RC{$sample}{$circ}=0;
      }
      print OUT "\t$RC{$sample}{$circ}";
   }
   print OUT "\n";
}
close OUT;
close BED;

system("bedtools sort -i circ.bed >circ.sorted.bed");
