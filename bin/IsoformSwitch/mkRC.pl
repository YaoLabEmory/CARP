open FIG,"<../../../Rawdata/sample_names_AR.txt";
while(<FIG>){
   chomp;
   push(@sample,$_);
}
close FIG;

foreach $sample (@sample){
   open FIG,"<../$sample/circlist";
   while(<FIG>){
      chomp;
      $samplenum{$_}++;
   }
   close FIG;
}

foreach $sample (@sample){
   open FIG,"<../$sample/Junction.Ratio";
   while(<FIG>){
      chomp;
      @_=split(/\s+/);
      @info=split(/:/);
      @junc=split(/:|-/,$_[0]);
      $circ="$info[0]".":$info[1]";
      if($samplenum{$circ}<@sample){next;}
      if($junc[-1]<=$junc[-2]){next;}
      $RC{$_[0]}{$sample}=$_[1];
      $site{$_[0]}++;
   }
   close FIG;
}

open OUT,">Junction.RC";

foreach $sample (@sample){
   print OUT "\t$sample";
}
print OUT "\n";

foreach $site (keys %site){
   print OUT "$site";
   foreach $sample (@sample){
      if(!exists $RC{$site}{$sample}){$RC{$site}{$sample}=0;}
      print OUT "\t$RC{$site}{$sample}";
   }
   print OUT "\n";
}
close OUT;

