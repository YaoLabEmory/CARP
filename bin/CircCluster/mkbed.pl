parse_command_line();

open FIG,"<../../../confident/confident_circ_$sample.xls";
open OUT,">circ.bed";
while(<FIG>){
   chomp;
   @_=split(/\s+|-|:/);
   if($_[1]>=$_[2]){next;}
   print OUT "$_[0]\t$_[1]\t$_[2]\n";
}
close FIG;
close OUT;

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
    perl mkbed.pl -i [-h]
    i  : sample name [HOG_Day0_2]
    h  : display the help information.
EOQ
exit(0);
}
