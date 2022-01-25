system("cat ../MergeCirc/confident/confident_circ_* |cut -f 1|sort|uniq >ConfidentCircList");
open FIG,"<ConfidentCircList";
while(<FIG>){
   chomp;
   $conf{$_}++;
}
close FIG;

open FIG,"<../MergeCirc/circlist/juncref-map-hg38/FP.circRNA";
while(<FIG>){
   chomp;
   $FP{$_}++;
}
close FIG;

print "Up:\n";
open FIG,"<DEup.xls";
open OUT,">DEup.confident.xls";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   if(/random/){
      print "Random:\t$_[-3]\n";
      next;
   }
   if(exists $FP{$_[-3]}){
      print "FalsePositive:\t$_[-3]\n";
      next;
   }
   if(exists $conf{$_[-3]}){
      print OUT "$_\n";
   }
   else{
      print "NonConfident:\t$_[-3]\n";
   }
}
close FIG;

print "Down:\n";
open FIG,"<DEdown.xls";
open OUT,">DEdown.confident.xls";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   if(/random/){
      print "Random:\t$_[-3]\n";
      next;
   }
   if(exists $FP{$_[-3]}){
      print "FalsePositive:\t$_[-3]\n";
      next;
   }
   if(exists $conf{$_[-3]}){
      print OUT "$_\n";
   }
   else{
      print "NonConfident:\t$_[-3]\n";
   }
}
system("rm ConfidentCircList");
system("cat DEup.confident.xls DEdown.confident.xls >DEcirc.confident.xls");
