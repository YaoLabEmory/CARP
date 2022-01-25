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

open FIG,"<MultiExonCirc.bed";
open OUT,">IntronRetension";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   if($boundary{$_[0]}{$_[1]} && $boundary{$_[0]}{$_[2]} && !$exon{$_[0]}{$_[1]}{$_[2]}){
      $inres{$_[-1]}=$_;
      print OUT "$_\n";
   }
}
close FIG;
close OUT;

open FIG,"<MultiExonCirc.bed";
open OUT,">IntronSkipping";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   if(exists $inres{$_[-1]}){;}
   else{
      print OUT "$_\n";
   }
}
close FIG;
close OUT;

