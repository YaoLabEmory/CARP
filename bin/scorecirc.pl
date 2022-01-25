open FIG,"<../../bin/config";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   $config{$_[0]}=$_[1];
}
close FIG;

$gtf=$config{"gtf"};
$circ="circlist.bed";

open FIG,"<$gtf";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   if($_[2] eq "exon"){
      $_[3]=$_[3]-1;
      $_[-1]=~s/"//g;
      @info=split(/\;/,$_[-1]);
      @gene=split(/\s+/,$info[0]);
      $gene=$gene[-1];
      @tran=split(/\s+/,$info[-2]);
      $tran=$tran[-1];
      $gene{$tran}=$gene;
      $gene{$_[0]}{$_[3]}=$gene;
      $gene{$_[0]}{$_[4]}=$gene;
      push(@{$tran{$_[0]}{$_[3]}},$tran);
      push(@{$tran{$_[0]}{$_[4]}},$tran);
   }
   else{;}
}
close FIG;

open FIG,"<$circ";
open OUT,">$circ.gene";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   if(exists $gene{$_[0]}{$_[1]} && exists $gene{$_[0]}{$_[2]}){
      foreach $start (@{$tran{$_[0]}{$_[1]}}){
         foreach $end (@{$tran{$_[0]}{$_[2]}}){
            if($start eq $end){
               if(exists $best{$_[0]}{$_[1]}{$_[2]}){;}
               else{
                  print OUT "$_\t$end\t2\t$gene{$end}\n";
                  $best{$_[0]}{$_[1]}{$_[2]}=$end;
                  $score2++;
               }
            }
         }
      }
      if(exists $best{$_[0]}{$_[1]}{$_[2]}){;}
      else{
         $tran=@{$tran{$_[0]}{$_[1]}}[0];
         $score1++;
         print OUT "$_\t$tran\t1\t$gene{$tran}\n";}
   }
   elsif(exists $gene{$_[0]}{$_[1]}){
      $tran=@{$tran{$_[0]}{$_[1]}}[0];
      $score1++;
      print OUT "$_\t$tran\t1\t$gene{$tran}\n";
   }
   elsif(exists $gene{$_[0]}{$_[2]}){
      $tran=@{$tran{$_[0]}{$_[2]}}[0];
      $score1++;
      print OUT "$_\t$tran\t1\t$gene{$tran}\n";
   }
   else{
      $score0++;
      print OUT "$_\tnogene\t0\tnogene\n";
   }
}

print "2: $score2\n";
print "1: $score1\n";
print "0: $score0\n";

