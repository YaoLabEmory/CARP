open FIG,"<../../../bin/config";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   $config{$_[0]}=$_[1];
}
close FIG;

$datapath="../../../Rawdata/";
$length=$config{"length"};

open FIG,"<$datapath/sample_names.txt";
while(<FIG>){
   chomp;
   push(@sample,$_);
}
close FIG;

foreach $sample (@sample){

%RC=();

for $i (1..2){
   %reads=();
   open FIG,"<../../juncreads2genome-$length"."bp/$sample"."_$i.sam";
   while(<FIG>){
      chomp;
      @_=split(/\t/);
      if($_[4]>20){
         $reads{$_[0]}++;
      }
   }
   close FIG;

   open FIG,"<../../juncreads2trans-$length"."bp/$sample"."_$i/accepted_hits.sam";
   while(<FIG>){
      chomp;
      @_=split(/\t/);
      if($_[4]>20){
         $reads{$_[0]}++;
      }
   }
   close FIG;

   open FIG,"<../$sample"."_$i.candjuncreads-$length"."bp.sam";
   open OUT,">>$sample.juncreads-$length"."bp.sam";
   while(<FIG>){
      chomp;
      @_=split(/\t/);
      if(($_[4]>20)&& !exists $reads{$_[0]}){
         $RC{$_[2]}++;
         print OUT "$_\n";
      }
   }
   close FIG;
   close OUT;
}

open OUT,">$sample.RC";
foreach $circ (sort keys %RC){
   print OUT "$circ\t$RC{$circ}\n";
}
close OUT;
}
