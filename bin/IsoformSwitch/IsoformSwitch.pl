open FIG,"AS.xls";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   @info=split(/:|-/,$_[0]);
   $circ="$info[0]".":$info[1]"."-$info[2]";
   $start=$info[3];
   $end=$info[4];
   $pvalue{$circ}{$start}{$end}=$_[-2];
   $pvalue{$circ}{$end}{$start}=$_[-2];
   $inclevdif{$circ}{$start}{$end}=$_[-3];
   $inclevdif{$circ}{$end}{$start}=$_[-3];
}
close FIG;

open OUT,">IsoformSwitch.xls";
foreach $circ (keys %pvalue){
   foreach $start (keys %{$pvalue{$circ}}){
      foreach $end (keys %{$pvalue{$circ}{$start}}){
         if($pvalue{$circ}{$start}{$end}<0.05 && abs($inclevdif{$circ}{$start}{$end})>0.2){
	    $flag=0;
            foreach $end2 (keys %{$pvalue{$circ}{$start}}){
	       if(abs($inclevdif{$circ}{$start}{$end2})>0.2 && $inclevdif{$circ}{$start}{$end2}*$inclevdif{$circ}{$start}{$end}<0){
		  if($start>$end){
		     print OUT "$circ\t$end-$start\t$inclevdif{$circ}{$start}{$end}\t$end2-$start\t$inclevdif{$circ}{$start}{$end2}\n";
		  }
		  else{
	             print OUT "$circ\t$start-$end\t$inclevdif{$circ}{$start}{$end}\t$start-$end2\t$inclevdif{$circ}{$start}{$end2}\n";
	          }
		  $flag++;
		  last;
	       }
	    }
            if(!$flag){
	       if($start>$end){
		       #print "$circ\t$end-$start\t$inclevdif{$circ}{$start}{$end}\t-\t-\t-\n";
	       }
	       else{
		       #print "$circ\t$start-$end\t$inclevdif{$circ}{$start}{$end}\t-\t-\t-\n";
	       }
	    }
	 }
      }
   }
}
close OUT;

system("mv IsoformSwitch.xls tmp");
open FIG,"<tmp";
open OUT,">IsoformSwitch.xls";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   @junc1=split(/-/,$_[1]);
   @junc2=split(/-/,$_[3]);
   $lengthchange=$junc1[1]-$junc1[0]-($junc2[1]-$junc2[0]);
   if($lengthchange*$_[2]>0){$change="long2short";}
   else{$change="short2long";}
   print OUT "$_\t$change\n";
}
system("rm tmp");
close FIG;
close OUT;

open FIG,"<IsoformSwitch.xls";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   $event="$_[0]:$_[1]";
   $change{$event}=$_[-1];
}
close FIG;

open FIG,"<AS.xls";
open OUT,">AS.annotate.xls";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   if(exists $change{$_[0]}){
      print OUT "$_\t$change{$_[0]}\n";
   }
   elsif($_[-2]<0.05 && abs($_[-3])>0.2){
      print OUT "$_\tUnsureSignificant\n";
   }
   else{
      print OUT "$_\tNotSignificant\n";
   }
}

