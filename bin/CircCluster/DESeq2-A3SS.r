library(DESeq2)

#step1: calculate normfactor
config<-read.table(file="../../../../../bin/config")
length<-config[which(config[,1]=="length"),2]

ARS<-read.table(file="../../../../../Rawdata/sample_names_AR.txt")[,1]
RMS<-read.table(file="../../../../../Rawdata/sample_names_RM.txt")[,1]

RMJ<-read.table(file=paste0("../../../../juncmap/",length,"bp/summary.txt"),row.names=1,header=T)
RMJ<-RMJ[RMS,2]
RMM<-read.table(file="../../../../../RNAseq/summary.txt",header=T,row.name=1)
RMM<-RMM[RMS,2]
NF<-RMJ/RMM
NF<-NF/(min(NF))

#step2: normalize
RC<-read.table(file="A3SS.expression",header=F,row.names=1)
names(RC)<-RMS
RC<-sweep(RC,MARGIN = 2,NF,FUN = "/")
rowname<-row.names(RC)
RC <- sapply(RC, as.integer)
row.names(RC)<-rowname
mean<-apply(RC,1,mean)
RC<-RC[mean>2,]

#step3: DESeq call Diff
condition=c(rep("case",3),rep("control",3))
colData=data.frame(condition=condition)
levels(colData$condition)=c("control","case")
#colData$condition = relevel(colData$condition, ref="control")
dds=DESeqDataSetFromMatrix(countData =RC,colData = colData,design= ~condition)
dds=DESeq(dds)
result=results(dds)

#step4: add information
result<-as.data.frame(result)
result$fdr<-p.adjust(result$pvalue,method="fdr")
resultRC<-cbind(RC,result)
resultRC<-resultRC[order(resultRC$fdr),]

write.table(resultRC,file="A3SS.DESeq.xls",row.names=TRUE,sep="\t",quote=FALSE)


