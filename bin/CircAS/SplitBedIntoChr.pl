parse_command_line();

open FIG,"<$bed";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   if($_[0] eq $CHR){;}
   else{
      close OUT;
      $CHR=$_[0];
      open OUT,">$CHR";
   }
   print OUT "$_\n";
}
close OUT;


sub parse_command_line {
    if(!@ARGV){usage();}
    else{
    while (@ARGV) {
        $_ = shift @ARGV;
        if    ($_ =~ /^-i$/) { $bed   = shift @ARGV; }
        else {
            usage();
        }
    }
    }
}

sub usage {
    print STDERR <<EOQ;
    perl SplitBedIntoChr.pl -i [-h]
    i  : input sortedbed file
    h  : display the help information.
EOQ
exit(0);
}
