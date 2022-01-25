library(ggplot2)

config<-read.table(file="../../bin/config")
length<-config[which(config[,1]=="length"),2]
AR<-read.table(file="../../Rawdata/sample_names_AR.txt")[,1]

for(i in c(1:length(AR))){

juncfile=paste("../juncmap/",length,"bp/",AR[i],"-logRatio",sep="")
lastfile=paste("../linearlastmap/MAPQ20/",AR[i],"-logRatio",sep="")
pdffile=paste(AR[i],".Ratio.pdf",sep="")
conffile=paste("confident_circ_",AR[i],".xls",sep="")

junc<-read.table(file=juncfile)
last<-read.table(file=lastfile)

junc[,3]<-factor(c("junc"))
last[,3]<-factor(c("last"))

data<-rbind(junc,last)

names(data)<-c("pos","Ratio","Type")

ggplot(data,aes(x=Ratio,colour=Type,fill=Type))+geom_density(alpha=0.4)+
   theme_classic()+
   theme(text = element_text(size=30))+
   theme(legend.position="bottom")+
   xlab("RR/RM ratio")+
   xlim(-3,3)
ggsave(pdffile)

linear<-last
lratio<-sort(linear[,2])
l95<-lratio[round(length(lratio)*0.95)]
circ<-length(junc[,1])
print(circ)
confjunc<-junc[junc[,2]>l95,]
print(l95)
conf<-length(confjunc[,1])
print(conf)
FDR<-1-conf/circ
print(FDR)
write.table(confjunc,file=conffile,sep="\t",row.names=F,col.names=F,quote=F)

}
