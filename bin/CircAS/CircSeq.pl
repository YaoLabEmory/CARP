open FIG,"<../../../../../bin/config";
while(<FIG>){
   chomp;
   @_=split(/\t/);
   $config{$_[0]}=$_[1];
}
close FIG;

$genome=$config{"genome"};

open FIG,"<../../../../circlist/circlist.bed.gene";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   $circ="$_[0]".":$_[1]"."-$_[2]";
   $strand{$circ}=$_[3];
}
close FIG;

system("bedtools getfasta -tab -fi $genome -bed ../circRNA.bed -fo circ.bed.seq.tab");


open FIG,"<circ.bed.seq.tab";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   $seq{$_[0]}=$_[1];
}
close FIG;

open FIG,"<../circRNA.bed";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   $exon="$_[0]".":$_[1]"."-$_[2]";
   $circseq{$_[-1]}="$circseq{$_[-1]}"."$seq{$exon}";
}
close FIG;

open OUT,">circseq.fa";
open TAB,">circseq.tab";
foreach $circ (keys %circseq){
   if($strand{$circ} eq "-"){
      $circseq{$circ}=revcomp($circseq{$circ});
   }
   print OUT ">$circ\n$circseq{$circ}\n";
   print TAB "$circ\t$circseq{$circ}\n";
}
close OUT;
close TAB;


system("rm circ.bed.seq.tab");

sub revcomp(@_){
   my $dna = shift;
   my $revcomp = reverse($dna);
   $revcomp =~ tr/ACGTacgt/TGCAtgca/;
   return $revcomp;
}

