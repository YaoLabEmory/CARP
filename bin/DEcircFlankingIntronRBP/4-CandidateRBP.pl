open FIG,"<../DEcirc.confident.xls";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   if($_[13]>0.05 || $_[8]*$_[-2]>0 ||$_[-1] eq "NA"){next;}
   $circ=$_[-3];
   $CNT++;
   %cnt=();
   open CIRC,"<$circ.intersect.log";
   while(<CIRC>){
      chomp;
      if(/chr/){
         $cnt{$RBP}++;
      }
      else{$RBP=$_;}
   }
   close CIRC;
   foreach $RBP (keys %cnt){
      if($cnt{$RBP}==2){
	    $sum{$RBP}++;
      }
   }
}
close FIG;

print "#Total CircRNA: $CNT\n";
foreach $RBP (keys %sum){
   print "$RBP\t$sum{$RBP}\n";
}
