parse_command_line();

open FIG,"<../../../juncmap/8bp/$sample.RC";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   $RC{$_[0]}=$_[1];
}
close FIG;

open FIG,"<circ.sorted.bed";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   push(@{$junc{$_[0]}{$_[2]}},$_[1]);
}
close FIG;

open OUT,">Alternative3circ";
foreach $chr (keys %junc){
   foreach $site (keys %{$junc{$chr}}){
      print OUT "$chr\t";
      foreach $junc (@{$junc{$chr}{$site}}){
         print OUT "$junc,";
      }
      $num=@{$junc{$chr}{$site}};
      print OUT "\t$site\t$num\n";
   }
}
close OUT;

open FIG,"<Alternative3circ";
open OUT,">Alternative3circ.RC.Ratio";
while(<FIG>){
   chomp;
   $RC=0;
   @_=split(/\s+/);
   @start=split(/,/,$_[1]);
   @end=split(/,/,$_[2]);
   print OUT "$_\t";
   foreach $start (@start){
      $circ="$_[0]".":$start"."-$end[0]";
      print OUT "$RC{$circ},";
      $RC=$RC+$RC{$circ};
   }
   print OUT "\t";
   foreach $start (@start){
      $circ="$_[0]".":$start"."-$end[0]";
      $ratio=$RC{$circ}/$RC;
      printf OUT "%.2f,",$ratio;
   }
   print OUT "\n";
}

sub parse_command_line {
    if(!@ARGV){usage();}
    else{
    while (@ARGV) {
	$_ = shift @ARGV;
	if    ($_ =~ /^-i$/) { $sample   = shift @ARGV; }
	else {
	    usage();
	}
    }
    }
}

sub usage {
    print STDERR <<EOQ; 
    perl Alternative3circ.pl -i [-h]   
    i  : sample name [HOG_AR_Day0_2]
    h  : display the help information.
EOQ
exit(0);
}
