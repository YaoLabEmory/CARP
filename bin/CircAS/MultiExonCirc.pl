open FIG,"<../../../../bin/config";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   $config{$_[0]}=$_[1];
}
close FIG;

$gtf=$config{"gtf"};

open FIG,"<$gtf";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   if($_[2] eq "exon"){
      $boundary{$_[0]}{$_[3]-1}++;
      $boundary{$_[0]}{$_[4]}++;
      $exon{$_[0]}{$_[3]-1}{$_[4]}++;
   }
}
close FIG;

open FIG,"<circRNA.bed";
open OUT,">MultiExonCirc.bed";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   @circ=split(/:|-/,$_[-1]);
   if($boundary{$circ[0]}{$circ[1]} && $boundary{$circ[0]}{$circ[2]} && !$exon{$circ[0]}{$circ[1]}{$circ[2]}){
      print OUT "$_\n";
   }
}
