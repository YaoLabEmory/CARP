open FIG,"<../../bin/config";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   $config{$_[0]}=$_[1];
}
close FIG;

open FIG,"<$config{gtf}";
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
      push(@{$start{$tran}},$_[3]);
      push(@{$end{$tran}},$_[4]);
      $strand{$tran}=$_[6];
   }
   else{;}
}
close FIG;

open FIG,"<../DEcirc.confident.xls";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   if($_[13]>0.05 || $_[8]*$_[-2]>0 ||$_[-1] eq "NA"){next;}
   $circ{$_[-3]}++;
}
close FIG;

open FIG,"<../../MergeCirc/circlist/circlist.bed.gene";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   $circ="$_[0]".":$_[1]"."-$_[2]";
   $score{$circ}=$_[-2];
   $tran{$circ}=$_[4];
}
close FIG;

foreach $circ (keys %circ){
   if($score{$circ}<2){next;}
   @tmp=split(/:|-/,$circ);
   if($strand{$tran{$circ}} eq "-"){
      @end=reverse (@{$start{$tran{$circ}}});
      @start=reverse (@{$end{$tran{$circ}}});
      $start=$tmp[2];
      $end=$tmp[1];
   }
   else{
      @start=@{$start{$tran{$circ}}};
      @end=@{$end{$tran{$circ}}};
      $start=$tmp[1];
      $end=$tmp[2];
   }
   #print "$start\t$end\n";################
   #print "@start\n";###############
   #print "@end\n";##############
   foreach ($i=0;$i<@start;$i++){
      if($start[$i]==$start){
         $startexon=$i+1;
	 if($end[$i-1]<$start[$i]){
            $upintron="$tmp[0]"."\t$end[$i-1]"."\t$start[$i]";
         }
	 else{
	    $upintron="$tmp[0]"."\t$start[$i]"."\t$end[$i-1]";
	 }
	 last;
      }
   }
   foreach ($i=0;$i<@end;$i++){
      if($end[$i]==$end){
         $endexon=$i+1;
	 if($end[$i]<$start[$i+1]){
            $downintron="$tmp[0]"."\t$end[$i]"."\t$start[$i+1]";
         }
	 else{
	    $downintron="$tmp[0]"."\t$start[$i+1]"."\t$end[$i]";
	 }
	 last;
      }
   }
   system("mkdir $circ");
   open UP,">$circ/UpIntron.bed";
   print UP "$upintron\n";
   open DOWN,">$circ/DownIntron.bed";
   print DOWN "$downintron\n";
   close UP;
   close DOWN;
   $upintron="";
   $downintron="";
   system("liftOver $circ/UpIntron.bed ../../bin/LiftOverMapChain/hg38ToHg19.over.chain $circ/UpIntron-hg19.bed $circ/UpIntron-unmappedhg19.bed");
   system("liftOver $circ/DownIntron.bed ../../bin/LiftOverMapChain/hg38ToHg19.over.chain $circ/DownIntron-hg19.bed $circ/DownIntron-unmappedhg19.bed");
}
