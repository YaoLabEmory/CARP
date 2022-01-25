$sample="HOG_AR_Day0_1";
$juncreflength=298;

parse_command_line();
$half=$length/2;
$start=$juncreflength/2-$half;

open FIG,"<./MergeCirc/circlist/juncref.fa";
while(<FIG>){
   chomp;
   if(/>/){
      s/>//;
      $ref=$_;
   }
   else{
      $junc=substr($_,$start,$length);
      $junc=~tr/acgt/ACGT/;
      $junc{$ref}=$junc;
      $juncrevcomp{$ref}=revcomp($junc{$ref});
   }
}
close FIG;
print "Finish reading ref...\n";

for $i (1..2){
%ref=%info=();
open FIG,"<./MergeCirc/juncmap/$sample"."_$i.mapped.sam";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   $ref{$_[0]}=$_[2];
   $info{$_[0]}=$_;
}
close FIG;
print "Finish reading sam $i...\n";

open FIG,"<./MergeCirc/juncmap/$sample"."_$i.fq";
open OUT,">./MergeCirc/juncmap/$sample"."_$i.candjuncreads-$length"."bp.fq";
open SAM,">./MergeCirc/juncmap/$sample"."_$i.candjuncreads-$length"."bp.sam";
$cnt=0;
while(<FIG>){
   chomp;
   $cnt++;
   if($cnt%4==1){
      $name=substr($_,1,);
   }
   elsif($cnt%4==2){
      $seq=$_;
      if(/$junc{$ref{$name}}/||/$juncrevcomp{$ref{$name}}/){
         $flag=1;
      }
      else{$flag=0;}
   }
   elsif($cnt%4==0){
      if($flag){
         print OUT "@"."$name\n$seq\n+\n$_\n";
         print SAM "$info{$name}\n";
      }
   }
}
close FIG;
close OUT;
close SAM;
print "Finish writing fq $i...\n";
}

print "Finished!";

sub revcomp(@_){
   my $dna = shift;
   my $revcomp = reverse($dna);
   $revcomp =~ tr/ACGTacgt/TGCATGCA/;
   return $revcomp;
}

sub parse_command_line {
    if(!@ARGV){usage();}
    else{
    while (@ARGV) {
	$_ = shift @ARGV;
	if    ($_ =~ /^-i$/) { $sample   = shift @ARGV; }
	elsif ($_ =~ /^-l$/) { $length  = shift @ARGV; }
	else {
	    usage();
	}
    }
    }
}

sub usage {
    print STDERR <<EOQ; 
    perl juncreads.pl -i -l [-h]   
    i  : input sample name
    l  : seq length that should be mathched with the junction site [16]
    h  : display the help information.
EOQ
exit(0);
}
