$outpath="../../";
$datapath="../../Rawdata";
$out="circlist.bed";

system("cat ../../Rawdata/sample_names_RM.txt ../../Rawdata/sample_names_AR.txt >../../Rawdata/sample_names.txt");
open FIG,"<$datapath/sample_names.txt";
while(<FIG>){
   chomp;
   push(@sample,$_);
}
close FIG;

foreach $sample (@sample){
   open FIG,"<$outpath/CIRCexplorer2/$sample/circularRNA_known.txt";
   while(<FIG>){
      chomp;
      @_=split(/\t/);
      $chr=$_[0];
      $start=$_[1];
      $end=$_[2];
      $circ{$chr}{$start}{$end}++;
      $strand{$chr}{$start}{$end}=$_[5];
   }
   close FIG;
   open FIG,"<$outpath/CIRIquant/$sample/circ/$sample.ciri";
   while(<FIG>){
      chomp;
      @_=split(/\t/);
      if($_[0] ne "circRNA_ID"){
         $chr=$_[1];
         $start=$_[2]-1;
         $end=$_[3];
         $circ{$chr}{$start}{$end}++;
         $strand{$chr}{$start}{$end}=$_[10];
      }
   }
   close FIG;
   open FIG,"<$outpath/findcirc/$sample/circ_candidates.bed";
   while(<FIG>){
      chomp;
      @_=split(/\t/);
      $chr=$_[0];
      $start=$_[1];
      $end=$_[2];
      $circ{$chr}{$start}{$end}++;
      $strand{$chr}{$start}{$end}=$_[5];
   }
   close FIG;
   open FIG,"<$outpath/MapSplice/$sample/circular_RNAs.txt";
   while(<FIG>){
      chomp;
      @_=split(/\t/);
      @chr=split(/~/,$_[0]);
      $start=$_[1]-1;
      $end=$_[2];
      $circ{$chr[0]}{$start}{$end}++;
      $strand{$chr[0]}{$start}{$end}=substr($_[5],0,1);
   }
   close FIG;
}

open OUT,">$out";

foreach $chr (sort keys %circ){
   foreach $s (sort keys %{$circ{$chr}}){
      foreach $e (keys %{$circ{$chr}{$s}}){
         print OUT "$chr\t$s\t$e\t$strand{$chr}{$s}{$e}\n";
      }
   }
}

