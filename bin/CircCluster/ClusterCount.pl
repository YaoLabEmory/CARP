open FIG,"<Alternative3circ";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   $end=$_[2];
   @_=split(/\,/,$_[1]);
   if(@_>1){
      $cnt++;
      $CNT=$CNT+@_;
      foreach $start (@_){
         $clustercirc3{$start}{$end}++;
         $clustercirc{$start}{$end}++;
      }
   }
   else{
   }
}
close FIG;
print "Number of Alternative3circsite: $cnt\n";
print "Number of Alternative3circ: $CNT\n";

$cnt=0;
$CNT=0;
open FIG,"<Alternative5circ";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   $start=$_[1];
   @_=split(/\,/,$_[2]);
   if(@_>1){
      $cnt++;
      $CNT=$CNT+@_;
      foreach $end (@_){
         $clustercirc5{$start}{$end}++;
         $clustercirc{$start}{$end}++;
      }
   }
   else{
   }
}
close FIG;
print "Number of Alternative5circsite: $cnt\n";
print "Number of Alternative5circ: $CNT\n";

$cnt=0;
foreach $start (keys %clustercirc){
   foreach $end (keys %{$clustercirc{$start}}){
      if(exists $clustercirc3{$start}{$end} && $clustercirc5{$start}{$end}){
         $cnt++;
      }
   }
}
print "Number of 5'3'circ: $cnt\n";
