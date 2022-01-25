parse_command_line();
$bsjcutoff=2;
$cutoff=$bsjcutoff/2;
################### read in BSJreads ######################
open FIG,"<$BSJreads";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   $BSJreads{$_[0]}++;
}
close FIG;

################### read in circlist ######################
open FIG,"<$circlist";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   $chr=$_[0];
   $start=$_[1];
   $end=$_[2];
   $circ="$chr".":$start"."-$end";
   $bsj{$circ}=$_[3];
   if($_[3]>=$bsjcutoff){
      $list{$circ}++;
   }
}
close FIG;

foreach $circ (keys %list){
   @tmp=split(/:|-/,$circ);
   $chr=$tmp[0];
   $start=$tmp[1];
   $end=$tmp[2];
   system("mkdir $circ");
   %read=%edge=%cnt=();
   ################## ReadsInCirc ############################
   open FIG,"<$chr";
   open OUT,">$circ/CircReads.bed";
   while(<FIG>){
      chomp;
      @_=split(/\t/);
      if($_[0] eq $chr && $_[1]>=$start && $_[2]<=$end){
         print OUT "$_\n";
      }
   }
   close FIG;
   close OUT;

   ################## FilterReads #################################
   open FIG,"<$circ/CircReads.bed";
   while(<FIG>){
      chomp;
      @_=split(/\t/);
      @info=split(/\//,$_[3]);
      $read{$info[0]}{$info[1]}++;
   }  
   close FIG;

   open FIG,"<$circ/CircReads.bed";
   open OUT,">$circ/CircReads.filter.bed";
   while(<FIG>){
      chomp;
      @_=split(/\t/);
      @info=split(/\//,$_[3]);
      if(exists $read{$info[0]}{"1"} && exists $read{$info[0]}{"2"}){
         print OUT "$_\n";
      }
      elsif(exists $BSJreads{$info[0]}){
         print OUT "$_\n";
      }  
      else{;}
   }
   close FIG;
   close OUT;

   ################# JuncSiteDetect ##################################
   open FIG,"<$circ/CircReads.filter.bed";
   while(<FIG>){
      chomp;
      @_=split(/\s+/);
      push(@{$edge{$_[3]}},$_[1]);
      push(@{$edge{$_[3]}},$_[2]);
   }
   close FIG;

   open OUT,">$circ/JuncSite";
   foreach $read (keys %edge){
         print OUT "$read\t";
         foreach $edge (@{$edge{$read}}){
            print OUT "$edge\t";
         }
         print OUT "\n";
   }
   close OUT;

   ################ Confident JuncPair ########################################
   %cnt=();
   open FIG,"<$circ/JuncSite";
   while(<FIG>){
      chomp;
      @_=split(/\s+/);
      #if(@_!=5){next;}
      for($i=2;$i+2<@_;$i=$i+2){
         $j=$i+1;
         $cnt{$_[$i]}{$_[$j]}++;
      }
   }
   close FIG;

   open OUT,">$circ/JuncSiteFreq";
   foreach $junc_1 (sort {$a<=>$b} keys %cnt){
      foreach $junc_2 (sort {$a<=>$b} keys %{$cnt{$junc_1}}){
         print OUT "$junc_1\t$junc_2\t$cnt{$junc_1}{$junc_2}\n";
      }
   } 
   close OUT;
   #################filter Confident juncpair###############################
   %cnt=();
   open FIG,"<$circ/JuncSiteFreq";
   while(<FIG>){
      chomp;
      @_=split(/\s+/);
      if($_[1]>$_[0]){
         $cnt{$_[0]}{$_[1]}=$_[2];
      }
   }
   close FIG;
   open OUT,">$circ/FilterStartJuncSiteFreq";
   foreach $junc_1 (sort {$a<=>$b} keys %cnt){
      $cnt=0;
      $end=0;
      foreach $junc_2 (sort {$a<=>$b} keys %{$cnt{$junc_1}}){
         if($cnt{$junc_1}{$junc_2}>$cnt){
            $cnt{$junc_1}{$end}=0;
            $cnt=$cnt{$junc_1}{$junc_2};
            $end=$junc_2;
         }
         else{
            $cnt{$junc_1}{$junc_2}=0;
         }
      }
      foreach $junc_2 (sort {$a<=>$b} keys %{$cnt{$junc_1}}){
         if($cnt{$junc_1}{$junc_2}>$cutoff){
             print OUT "$junc_1\t$junc_2\t$cnt{$junc_1}{$junc_2}\n";
         }
      }
   }
   close OUT;
   #############################################3   
   %cnt=();
   open FIG,"<$circ/FilterStartJuncSiteFreq";
   while(<FIG>){
      chomp;
      @_=split(/\s+/);
      $cnt{$_[1]}{$_[0]}=$_[2];
   }
   close FIG;
   open OUT,">$circ/FilterStartEndJuncSiteFreq";
   foreach $junc_1 (sort {$a<=>$b} keys %cnt){
      $cnt=0;
      $start=0;
      foreach $junc_2 (sort {$a<=>$b} keys %{$cnt{$junc_1}}){
         if($cnt{$junc_1}{$junc_2}>$cnt){
            $cnt{$junc_1}{$start}=0;
            $cnt=$cnt{$junc_1}{$junc_2};
            $start=$junc_2;
         }
         else{
            $cnt{$junc_1}{$junc_2}=0;
         }
      }
      foreach $junc_2 (sort {$a<=>$b} keys %{$cnt{$junc_1}}){
         if($cnt{$junc_1}{$junc_2}>$cutoff){
            print OUT "$junc_2\t$junc_1\t$cnt{$junc_1}{$junc_2}\n";
         }
      }
   }
   close OUT;
   ###########################################
   %cnt=();
   open FIG,"<$circ/FilterStartEndJuncSiteFreq";
   while(<FIG>){
      chomp;
      @_=split(/\s+/);
      $cnt{$_[0]}{$_[1]}=$_[2];
   }
   close FIG;   
   open OUT,">$circ/FilterStartEndOverlapJuncSiteFreq";
   $end=0;
   foreach $junc_1 (sort {$a<=>$b} keys %cnt){
      foreach $junc_2 (sort {$a<=>$b} keys %{$cnt{$junc_1}}){  
         if($junc_1>$end && $cnt{$junc_1}{$junc_2}>$cutoff){
            print OUT "$junc_1\t$junc_2\t$cnt{$junc_1}{$junc_2}\n";
            $end=$junc_2;
         }
         else{;}
      }
   }
   ###################Report gtf########################################
   open OUT,">>$chr.circRNA.bed";
   @circ=();
   @tmp=split(/:|-/,$circ);
   $chr=$tmp[0];
   push(@circ,$tmp[1]);
   open FIG,"<$circ/FilterStartEndOverlapJuncSiteFreq";
   while(<FIG>){
      chomp;
      @_=split(/\t/);
      if($_[0] ne $tmp[1] && $_[0] ne $tmp[2] && $_[1] ne $tmp[1] && $_[1] ne $tmp[2]){
         push(@circ,$_[0]);
         push(@circ,$_[1]);
      }
   }
   close FIG;
   push(@circ,$tmp[2]);
   
   for($i=0;$i<@circ;$i=$i+2){
      print OUT "$chr\t$circ[$i]\t$circ[$i+1]\t$circ\n";
   }
   close FIG;
   close OUT;
}

sub parse_command_line {
    if(!@ARGV){usage();}
    else{
    while (@ARGV) {
	$_ = shift @ARGV;
	if    ($_ =~ /^-i$/) { $circlist   = shift @ARGV; }
	elsif($_ =~ /^-j$/) {$BSJreads= shift @ARGV;}
        else {
	    usage();
	}
    }
    }
}

sub usage {
    print STDERR <<EOQ; 
    perl Pipeline.pl -i [-h]   
    i  : input circ file
    j  : BSJreads directory
    h  : display the help information.
EOQ
exit(0);
}

