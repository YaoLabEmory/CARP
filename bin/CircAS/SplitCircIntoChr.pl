$circ="/mnt/YaoFSS/data/Yli/CircoRNA/293TSHSY5YARnaseR/Merge293T/circlist/ConfCirc/AlternativeSpliceCirc/SingleCirc.gene";

parse_command_line();

open FIG,"<$circ";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   if($_[0] eq $CHR){;}
   else{
      close OUT;
      $CHR=$_[0];
      open OUT,">$CHR.circ";
   }
   print OUT "$_\n";
}
close OUT;

sub parse_command_line {
    if(!@ARGV){usage();}
    else{
    while (@ARGV) {
        $_ = shift @ARGV;
        if    ($_ =~ /^-i$/) { $circ   = shift @ARGV; }
        else {
            usage();
        }
    }
    }
}

sub usage {
    print STDERR <<EOQ;
    perl SplitCircIntoChr.pl -i [-h]
    i  : input circ file
    h  : display the help information.
EOQ
exit(0);
}
