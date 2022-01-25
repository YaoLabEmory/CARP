open FIG,"<../../../Rawdata/sample_names_RM.txt";
while(<FIG>){
   chomp;
   push(@RM,$_);
}
close FIG;

open FIG,"<../../../Rawdata/sample_names_AR.txt";
while(<FIG>){
   chomp;
   push(@AR,$_);
}
close FIG;

for($i=0;$i<@RM;$i++){
         %RC=();
         open CTL,"<$RM[$i].RC";
         while(<CTL>){
            chomp;
            @_=split(/\t/);
            $RC{$_[0]}=$_[1];
         }
         close CTL;
         $cnt=0;
         open RR,"<$AR[$i].RC";
         open OUT,">$AR[$i]-logRatio";
         while(<RR>){
            chomp;
            @_=split(/\t/);
            if($_[1]<2){next;}
            if(exists $RC{$_[0]}){
               $ratio=$_[1]/$RC{$_[0]};
               $logR=log($ratio)/log(10);
               print OUT "$_[0]\t$logR\n";
            }
            else{
               $logR=log($_[1]/0.1)/log(10);
               print OUT "$_[0]\t$logR\n";
               $cnt++;
            }
         }
         print "$cnt loci have no reads in CTL but have reads in RR-$i library\n";
         close RR;
         close OUT;
}
