open FIG,"<circRNA.bed";
while(<FIG>){
   chomp;
   @_=split(/\t+/);
   if(@_<4){print "ERROR: $_\n";}
   else{
      print OUT "$_\n";
      push(@{$junc{$_[-1]}},$_[1]);
      push(@{$junc{$_[-1]}},$_[2]);
      $chr{$_[-1]}=$_[0];
   }
}
close FIG;

open EXON,">circRNA.exon.bed";
open INTRON,">circRNA.intron.bed";
foreach $circ (keys %junc){
   @junc=@{$junc{$circ}};
   if(@junc>2){
      for($i=0;$i<@junc;$i=$i+2){
         if($junc[$i+1]>$junc[$i]){
            print EXON "$chr{$circ}\t$junc[$i]\t$junc[$i+1]\t$circ\n";
         }
      }
      for($i=1;$i<@junc-1;$i=$i+2){
         if($junc[$i+1]>$junc[$i]){
            print INTRON "$chr{$circ}\t$junc[$i]\t$junc[$i+1]\t$circ\n";
         }
      }
   }
}
close EXON;
close INTRON;

