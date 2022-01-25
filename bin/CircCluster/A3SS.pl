open FIG,"<../../../../Rawdata/sample_names_AR.txt";
while(<FIG>){
   chomp;
   push(@sample,$_);
}
close FIG;

$samplenum=@sample;

foreach $sample (@sample){
   open FIG,"<../$sample/Alternative3circ.RC.Ratio";
   while(<FIG>){
      chomp;
      %ratio=();
      @_=split(/\s+/);
      $chr=$_[0];
      $start=$_[2];
      @end=split(/,/,$_[1]);
      $circnum{$chr}{$start}{$sample}=$_[3];
      @JRC=split(/,/,$_[4]);
      foreach $JRC (@JRC){
         $TJRC{$chr}{$start}{$sample}=$TJRC{$chr}{$start}{$sample}+$JRC;
      }
      @ratio=split(/,/,$_[5]);
      for($i=0;$i<@end;$i++){
         $ratio{$end[$i]}=$ratio[$i];
      }
      @end = sort { $ratio{$b} <=> $ratio{$a} } keys %ratio;
      $domend{$chr}{$start}{$sample}=$end[0];
      $domratio{$chr}{$start}{$sample}=$ratio{$end[0]};
      foreach $end (@end){
         $end{$chr}{$start}{$end}++;
      }
   }
   close FIG;
}

open OUT,">A3SS";
foreach $chr (sort keys %circnum){
   foreach $start (sort keys %{$circnum{$chr}}){
      @sample=sort keys %{$circnum{$chr}{$start}};
      if(@sample<$samplenum) {next;}
      print OUT "$chr\t$start\t";
      foreach $sample (@sample){
         print OUT "$sample/";
      }
      print OUT "\t";
      foreach $sample (@sample){
         print OUT "$circnum{$chr}{$start}{$sample}/";
      }
      print OUT "\t";
      foreach $sample (@sample){
         print OUT "$TJRC{$chr}{$start}{$sample}/";
      }
      print OUT "\t";
      foreach $sample (@sample){
         print OUT "$domend{$chr}{$start}{$sample}/";
      }
      print OUT "\t";
      foreach $sample (@sample){
         print OUT "$domratio{$chr}{$start}{$sample}/";
      }
      print OUT "\t";
      foreach $end (keys %{$end{$chr}{$start}}){
         print OUT "$end/";
      }
      print OUT "\n";
   }
}
close OUT;
