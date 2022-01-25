AllEqual <- structure(function(
	##title<< 
	## Check if all values in a vector are the same
	##description<<
	## This function is used to check if all values in a vector are equal. It can be used for example to check if a time series contains only 0 or NA values.
	
	x
	### numeric, character vector, or time series of type ts
) {
	res <- FALSE
	x <- na.omit(as.vector(x))
	if (length(unique(x)) == 1 | length(x) == 0) res <- TRUE
	return(res)
	### The function returns TRUE if all values are equal and FALSE if it contains different values.
},ex=function(){
# check if all values are equal in the following vectors:
AllEqual(1:10)
AllEqual(rep(0, 10))
AllEqual(letters)
AllEqual(rep(NA, 10))
})


#library(DESeq2)

#step1: calculate normfactor
RC<-read.table(file="A2I.xls",header=T,row.names=1)
designs=c(rep(1,3),rep(0,3))

n0=sum(designs==0)
n1=sum(designs==1)
m0=apply(RC[,designs==0],1,mean)
m1=apply(RC[,designs==1],1,mean)

n=nrow(RC)

pval=rep(1,n)

for(i in 1:n){
   if(AllEqual(as.numeric(RC[i,c(1:6)]))){pval[i]=1}
   else if(AllEqual(as.numeric(RC[i,c(1:3)])) & AllEqual(as.numeric(RC[i,c(4:6)]))){pval[i]=0} else {
   pval[i]=t.test(RC[i,designs==0],RC[i,designs==1])$p.value
   }
}
fdr=p.adjust(pval,method='fdr')
A2IDif=m1-m0
res=cbind(RC,A2IDif=A2IDif,pval=pval, fdr=fdr)
res=res[order(abs(res$pval),decreasing = F),]

write.table(res,file="A2I.dif.xls",col.names=T,sep="\t",quote=FALSE)

data<-read.table(file="A2I.dif.xls",header=T,row.names=1)
data<-data[abs(data$pval)<0.05,]
data<-data[abs(data$A2IDif)>0.1,]
write.table(data,file="A2I.Pval0.05A2Idif0.1.xls",row.names=T,col.names=T,sep="\t",quote=F)

