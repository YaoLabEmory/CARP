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
   push(@{$junc{$_[0]}{$_[1]}},$_[2]);
}
close FIG;

open OUT,">Alternative5circ";
foreach $chr (keys %junc){
   foreach $site (keys %{$junc{$chr}}){
      print OUT "$chr\t$site\t";
      foreach $junc (@{$junc{$chr}{$site}}){
         print OUT "$junc,"
      }
      $num=@{$junc{$chr}{$site}};
      print OUT "\t$num\n";
   }
}

open FIG,"<Alternative5circ";
open OUT,">Alternative5circ.RC.Ratio";
while(<FIG>){
   chomp;
   $RC=0;
   @_=split(/\s+/);
   @start=split(/,/,$_[1]);
   @end=split(/,/,$_[2]);
   print OUT "$_\t";
   foreach $end (@end){
      $circ="$_[0]".":$start[0]"."-$end";
      print OUT "$RC{$circ},";
      $RC=$RC+$RC{$circ};
   }
   print OUT "\t";
   foreach $end (@end){
      $circ="$_[0]".":$start[0]"."-$end";
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
    perl Alternative5circ.pl -i [-h]
    i  : sample name [HOG_AR_Day0_2]
    h  : display the help information.
EOQ
exit(0);
}
