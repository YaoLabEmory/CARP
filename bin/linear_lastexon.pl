open FIG,"<../../bin/config";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   $config{$_[0]}=$_[1];
}
close FIG;

$gtf=$config{"gtf"};
$circ="circlist.bed.gene";
$genome=$config{"genome"};

open FIG,"<$gtf";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   $_[3]--;
   if($_[2] eq "exon"){
      $_[-1]=~s/"//g;
      @info=split(/\;/,$_[-1]);
      @tran=split(/\s+/,$info[-2]);
      $tran=$tran[-1];
      if($_[6] eq "+"){
         push(@{$start{$tran}},$_[3]);
         push(@{$end{$tran}},$_[4]);
      }
      elsif($_[6] eq "-"){
         unshift(@{$start{$tran}},$_[3]);
         unshift(@{$end{$tran}},$_[4]); 
      }
   }
   else{;}
}
close FIG;

open FIG,"<$circ";
open OUT,">last.bed";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   @start= @{$start{$_[-3]}};
   @end= @{$end{$_[-3]}};
   if($end[-1]==$_[2]||$start[-1]==$_[1]){
      $lastexon++;
   }
   elsif($start[-1] && $end[-1]){
      if(exists $last{$_[0]}{$start[-1]}{$end[-1]}){;}
      else{
         print OUT "$_[0]\t$start[-1]\t$end[-1]\t$_[3]\n";
         $last{$_[0]}{$start[-1]}{$end[-1]}++;
      }
   }
   elsif($_[5]<1){;}
   else{
      print "$_\n";
   }
}

print "$lastexon circ comes from last exon\n";

system("bedtools getfasta -fi $genome -bed last.bed -fo last.bed.fa");
system("bowtie2-build last.bed.fa last");
#system("rm last.bed");
#system("rm last.bed.fa");


