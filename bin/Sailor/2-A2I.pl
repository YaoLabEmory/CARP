open FIG,"<../Rawdata/sample_names_RM.txt";
while(<FIG>){
   chomp;
   unshift(@sample,$_);
}
close FIG;

foreach $sample (@sample){
   open FIG,"<$sample/results/$sample.sorted.fwd.sorted.rmdup.readfiltered.formatted.varfiltered.vcf";
   while(<FIG>){
      chomp;
      if(/##/){next};
      @_=split(/\s+/);
      $pos="$_[0]"."-$_[1]";
      $A2I{$pos}{$sample}=$_[5];
   }
   close FIG;
}

foreach $sample (@sample){
   open FIG,"<$sample/results/$sample.sorted.rev.sorted.rmdup.readfiltered.formatted.varfiltered.vcf";
   while(<FIG>){
      chomp;
      if(/##/){next};
      @_=split(/\s+/);
      $pos="$_[0]"."-$_[1]";
      $A2I{$pos}{$sample}=$_[5];
   }
   close FIG;
}

open OUT,">A2I.xls";
foreach $sample (@sample){
   print OUT "\t$sample";
}
print OUT "\n";

foreach $pos (keys %A2I){
   print OUT "$pos\t";
   foreach $sample (@sample){
      if($A2I{$pos}{$sample}){
         print OUT "\t$A2I{$pos}{$sample}";
      }
      else{
         print OUT "\t0";
      }
   }
   print OUT "\n";
}
close OUT;

