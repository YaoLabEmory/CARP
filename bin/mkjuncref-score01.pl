open FIG,"<../../bin/config";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   $config{$_[0]}=$_[1];
}
close FIG;

$genome=$config{"genome"};

open FIG,"<circlist.bed.gene";
open UP,">juncup.bed";
open DOWN,">juncdown.bed";

while(<FIG>){
   chomp;
   @_=split(/\s+/);
   if($_[-2]<2){
      $tmp=$_[2]-149;
      print UP "$_[0]\t$tmp\t$_[2]\n";
      $tmp=$_[1]+149;
      print DOWN "$_[0]\t$_[1]\t$tmp\n";
   }
}
close FIG;
close UP;
close DOWN;

system("bedtools getfasta -fi $genome -bed juncup.bed -fo juncup.bed.fa");
system("bedtools getfasta -fi $genome -bed juncdown.bed -fo juncdown.bed.fa");

$cnt=0;
open FIG,"<juncdown.bed.fa";
while(<FIG>){
   chomp;
   if(/>/){
      s/>//;
      @_=split(/:|-/);
      $cnt++;
      $name{$cnt}=$_;
      $chr{$cnt}=$_[0];
      $cor{$cnt}=$_[1];
   }
   else{
      $seq{$cnt}=$_;
   }
}
close FIG;

$cnt=0;
open FIG,"<juncup.bed.fa";
open OUT,">score01.juncref.fa";
while(<FIG>){
   chomp;
   if(/>/){
      s/>//;
      @_=split(/:|-/);
      $cnt++;
      print OUT ">$_[0]:$cor{$cnt}-$_[2]\n";
   }
   else{
      print OUT "$_"."$seq{$cnt}\n";
   }
}

#system("bowtie2-build score01.juncref.fa score01junc");
#system("rm score01.juncref.fa");
system("rm juncup.bed");
system("rm juncdown.bed");
system("rm juncup.bed.fa");
system("rm juncdown.bed.fa");


