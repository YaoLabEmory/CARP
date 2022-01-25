use List::Util qw[min max];

system("cat *circRNA.bed|cut -f 4|uniq >circlist");
system("cat *circ >circ.RC");

open FIG,"<circ.RC";
while(<FIG>){
  chomp;
  @_=split(/\s+/);
  $circ="$_[0]".":$_[1]"."-$_[2]";
  $JRC{$circ}=$_[-1]; 
}
close OUT;

open FIG,"<circlist";
open OUT,">Junction.Ratio";
while(<FIG>){
   chomp;
   $circ=$_;
   open CIRC,"<./$circ/JuncSiteFreq";
   %RC=();
   while(<CIRC>){
      chomp;
      @_=split(/\s+/);
      $RC{$_[0]}=$RC{$_[0]}+$_[-1];
      $RC{$_[1]}=$RC{$_[1]}+$_[-1];
   }
   close CIRC;
   open CIRC,"<./$circ/JuncSiteFreq";
   while(<CIRC>){
      chomp;
      @_=split(/\s+/);
      $total=max($JRC{$circ},$RC{$_[0]});
      $ratiostart=$_[-1]/$total;
      $total=max($JRC{$circ},$RC{$_[1]});
      $ratioend=$_[-1]/$total;
      $ratio=min($ratiostart,$ratioend);
      printf OUT "$circ:$_[0]-$_[1]\t%.2f\n",$ratio;
   }
   close CIRC;
}
close FIG;
close OUT;

